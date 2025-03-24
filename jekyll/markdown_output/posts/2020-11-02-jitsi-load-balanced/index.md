---
author:
- Patrick Schratz
authors:
- Patrick Schratz
categories:
- DevOps
date: 2020-11-02
excerpt: Jitsi Meet is a self-hosted Free and Open-Source Software
  (FOSS) video conferencing solution. During the recent COVID-19
  pandemic, the project became quite popular, and many companies decided
  to host their own Jitsi instance.
layout: post
og_image: og_image.jpg
title: Setting up a load-balanced Jitsi Meet instance
toc-title: Table of contents
---

Jitsi Meet is a self-hosted Free and Open-Source Software (FOSS) video
conferencing solution. During the recent COVID-19 pandemic, the project
became quite popular, and many companies decided to host their own Jitsi
instance.

<figure>
`<img alt="Illustration" src="banner.jpg" style=" width: 100%; height: auto">`{=html}
<figcaption>
Photo by Chuttersnap
</figcaption>
</figure>

There are many [different
ways](https://jitsi.github.io/handbook/docs/devops-guide) to install and
run [Jitsi](https://github.com/jitsi/jitsi-meet) on a machine. A popular
choice in the DevOps space is to use
[Docker](https://github.com/jitsi/docker-jitsi-meet) via
`docker-compose`, which was the method used in our scenario.

At cynkra, while we have been running our own Jitsi instance quite
happily for some months, there was a slightly challenging task coming
up: hosting a virtual meeting for approximately 100 participants.

## The Challenge

cynkra actively supports the local [Zurich R User
Group](https://www.meetup.com/Zurich-R-User-Group/). For one of their
[recent meetings](https://www.meetup.com/Zurich-R-User-Group), about 100
people RSVP'ed.

When browsing the load capabilities of a single Jitsi instance, we found
that the stock setup begins to experience some challenges at around 35
people and fails at around 70 people. The limiting factor appears to be
the "videobridge". One solution is to add a second videobridge to the
Jitsi instance. Jitsi can then distribute the load and should be able to
host more than 100 people in a meeting.

The best approach is to deploy the second videobridge on a new instance
to avoid running into CPU limitations on the main machine. While there
is a
[guide](https://github.com/jitsi/jitsi-meet/wiki/jitsi-meet-load-balancing-installation-Ubuntu-18.04-with-MUC-and-JID)
in the Jitsi Wiki and a
[video](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-videotutorials#how-to-load-balance-jitsi-meethttpsjitsiorgblogtutorial-video-how-to-load-balance-jitsi-meet)
that explains how to do it, many people still struggle
([1](https://github.com/jitsi/docker-jitsi-meet/issues/372),
[2](https://community.jitsi.org/t/how-can-i-add-extra-jvb-in-docker-meet/30911/36))
to get this set up successfully.

Hence, we thought it would be valuable to take another, hopefully simple
and understandable stab at explaining this task to the community.

## Load-balancing Jitsi Meet

In the following, we will denote the main machine on which Jitsi runs,
as MAIN. The second machine, which will only host a standalone
videobridge, will be named BRIDGE.

1.  The first step is to create a working installation on MAIN,
    following the [official docker
    guide](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker)
    from the Jitsi developers. There is no need to use Docker. An
    installation on the host system will also work.

    At this point, we assume that you already have installed Jitsi with
    SSL support at a fictitious domain.

2.  To be able to connect to the XMPP server (managed by `prosody`) on
    MAIN from BRIDGE (details in point 4 below), port 5222 needs to be
    exported to the public. This requires adding

    ``` sh
    ports:
      - "5222:5222"
    ```

    to the `prosody` section in `docker-compose.yml` and ensuring that
    the port is opened in the firewall (`ufw allow 5222`).

3.  On BRIDGE, start with the same `.env` and `docker-compose.yml` as
    MAIN.

    In `docker-compose.yml`, remove all services besides `jvb`. The
    videobridge will later connect to all services on MAIN.

    Make sure that `JVB_AUTH_USER` and `JVB_AUTH_PASSWORD` in `.env` are
    the same as on MAIN, otherwise the authentication will fail.

4.  On BRIDGE in `.env` change `XMPP_SERVER=xmpp.<DOMAIN>` to
    `XMPP_SERVER=<DOMAIN>`.

5.  Run `docker-compose up` and observe what happens. The videobridge
    should successfully connect to `<DOMAIN>`. On MAIN, in
    `docker logs jitsi_jicofo_1`, an entry should appear denoting that a
    new videobridge was successfully connected.

    It looks like

    ``` sh
    Jicofo 2020-10-23 19:01:52.173 INFO: [29] org.jitsi.jicofo.bridge.BridgeSelector.log() Added new videobridge: Bridge[jid=jvbbrewery@internal-muc.<DOMAIN>/d789de303e9b, relayId=null, region=null, stress=0.00]
    ```

    If you have another videobridge running on MAIN, you should see that
    the identifier of the new videobridge (here `d789de303e9b`) is
    different to your main videobridge identifier. On BRIDGE, the logs
    should show something like

    ``` sh
    INFO: Joined MUC: jvbbrewery@internal-muc.<DOMAIN>
    INFO: Performed a successful health check in PT0S. Sticky failure: false
    ```

To test that the external videobridge is active, one can disable the
main videobridge (`docker stop jitsi_jvb_1`) and try to enable the
camera in a new meeting.

## Troubleshooting and Tips

-   If you see something like
    `SASLError using SCRAM-SHA-1: not-authorized`, this indicates that
    the `JVB_AUTH_PASSWORD` and/or `JVB_AUTH_USER` on BRIDGE are
    incorrect.

-   If you change something in `.env` of MAIN, you need to delete all
    config folders before running `docker-compose up` again. Otherwise
    changes won't be picked up even when force destroying the
    containers.

-   Do not run `gen-passwords.sh` multiple times as `JVB_AUTH_PASSWORD`
    and BRIDGE will not be able to connect anymore.

-   Unrelated to the content above: if you want to create a user
    manually for your instance, the following command might be helpful:

    ``` sh
    docker exec jitsi_prosody_1 prosodyctl --config /config/prosody.cfg.lua register <USER> <DOMAIN> "<PASSWORD>"
    ```

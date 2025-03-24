---
author:
- Ben Ubah
authors:
- Ben Ubah
badges:
- bg: bg-success
  label: Community
categories:
- R
date: 2022-01-05
excerpt: Google Season of Docs provides support for open source projects
  to improve their documentation and gives professional technical
  writers an opportunity to gain experience in open source. The R
  Project participated in GSoD as an open-source organization for the
  first time this year.
image: banner.png
layout: post
og_image: banner.png
title: "Google Season of Docs with R: useR! Information Board"
toc-title: Table of contents
---

"Google Season of Docs (GSoD) provides support for open source projects
to improve their documentation and gives professional technical writers
an opportunity to gain experience in open source." (Source: [Program
website](https://developers.google.com/season-of-docs))

The program makes it possible for technical writers to work closely with
an open-source community they may or may not have been engaged with, to
solve real problems with high-quality documentation.

<figure>
`<img alt="dashboard for exploring useR! conference" src="banner.png" style=" width: 100%; height: auto">`{=html}
</figure>

In the end, an awareness of open source, of documentation and technical
writing is raised, while participating open source organizations benefit
from an improvement in their documentation. The R Project participated
in GSoD as an open-source organization for the first time this year
after several years of participating in Google Summer of Code (GSoC),
another open-source program focused on coding.

## The useR! conference

useR! is the main annual conference for the R user and developer
community that is organized by a community of volunteers and supported
by the R Foundation. It is organized by a different team of community
organizers each year and has been held since 2004. The useR! conference
program consists of both invited and user-contributed presentations in
addition to tutorials and other social events.

With so much historical information about useR! scattered around Git
repositories, useR! websites, and organizers' hard-disks, the R Project
proposed to organize useR! documentation with two outputs- an
information board and a knowledgebase. The knowledgebase was proposed to
take the form of an online book, inspired by examples such as the
[satRdays knowledgebase](https://knowledgebase.satrdays.org/). The
information board was proposed as a dashboard to interactively browse
historical information. These two projects were carried on concurrently
over a span of 6 months (May - November, 2021) during which my primary
responsibility as a technical writer was to curate historical useR!
conference data and develop the information board with this data.

## The Information board

Why an information board?

After participating in useR! 2021 as a part of the organizing committee,
I identified several gaps within the organizational process that an
information board could fill up. Organizers spend a lot of time looking
for information from past useR! conference websites, past organizers,
and other archives of un-structured or semi-structured data. This
process repeats each year for every useR! conference and this seems to
put a burden on past organizers or co-ordinators to continuously provide
information to future organizers.

To fill in these gaps, I proposed to: - gather data in a structured
format for at least the past six useR! conferences - build a dashboard
using this data-set - structure things in such a way that updating the
data files leads to an updated dashboard after a rebuild process

The final product could be found by accessing the following URL:
<https://bit.ly/infoboard-cynkra>

## Use cases

A typical useR! conference program consists of keynotes, regular talks,
lightning talks, poster sessions, tutorials and social events. The
organizing team for each conference would need to identify keynote
speakers, select talks and tutorials, and determine which social events
to offer. In addition to those, the organizing team would need to set up
partnerships for the conference - sponsors (that can contribute in
different ways) and partner organizations. To prospective organizers who
have never organized useR! or a conference of such capacity, it is
burdensome to sift through 15+ past useR! websites to search out the
type of tutorials that have been offered in the past, the number of
keynote presentations to offer and around what topics, or what kind of
social events to host.

It is difficult to ascertain if a talk has been presented in a useR! in
the past without access to structured and filterable historical data.

Furthermore, with diversity and inclusion in mind, it could be difficult
to determine presenters that have already presented many times before
(perhaps on a similar topic) and those from under-represented groups
that have only had a few chances to present talks at a useR!

For organizers to target sponsors who are interested in R and who may
have sponsored in the past within the location of the conference is hard
without data-driven assistance. For potential sponsors, it provides some
insight into the scope and reach of useR! conferences.

For entities like the R Foundation, R Consortium and R Forwards, the
information board provides an easy way to gain insights into the history
of useR! while planning for the future in a global and diverse context.

Other conferences beyond useR! could benefit from the information board
as it provides organized data around people, organizations, and
presentations that could be helpful in planning local and regional R
events.

## Tools

I used `flexdashboard` for the structure and layout of the dashboard,
`echarts4r` for charts, and `reactable` for interactive tables.

## Technical information

The source for this dashboard lives in a [GitLab
repository](https://gitlab.com/rconf/userinfoboard/) where
[issues](https://gitlab.com/rconf/userinfoboard/-/issues) or [merge
requests](https://gitlab.com/rconf/userinfoboard/-/merge_requests) can
be raised.

All the data are located in the [data
directory](https://gitlab.com/rconf/userinfoboard/-/tree/master/data)
and a description of the years which each dataset covers.

The charts and tables are produced from scripts in the [R
directory](https://gitlab.com/rconf/userinfoboard/-/tree/master/R) -
hopefully making it easier to reproduce them or use them in other
contexts.

The sidebar menu, footer and JavaScript codes are saved as HTML
fragments that are included via the YAML header of the `index.Rmd` file.

## License

The data is available for download under a CC BY 4.0 license, while the
R code is available under a GPL-3.0 license.

## Technical Writing experience

Having written R articles for [Open Data
Science](https://opendatascience.com/tag/r-trends/) in the past, the
experience gained from this GSoD project improved my technical writing
and project management skills. In a collaborative sense: I received and
implemented feedback several times a month from different volunteers
across several timezones, while working to produce the deliverable per
project-phase and covering the general scope of the project.

## Acknowledgements

This project would not have been possible at this time without support
from Google via the GSoD program. Much appreciation goes to the GSoD
admins for the R Project - Heather Turner and Matt Bannert - who did a
lot of admin work from the proposal to the final report. I also
appreciate Noa Tamir, who excellently managed the week-to-week
supervision of this work. I appreciate the help I received from several
volunteers on this project including past organizers who provided data
from their archives.

Finally, cynkra is passionate about open-source and the R community, and
this has provided an enabling environment for this project to succeed
and to continue succeeding.

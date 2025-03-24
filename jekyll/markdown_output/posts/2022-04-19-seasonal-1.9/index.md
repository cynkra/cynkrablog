---
author:
- Christoph Sax
authors:
- Christoph Sax
badges:
- bg: bg-warning
  label: CRAN
categories:
- R
- time-series
date: 2022-04-19
excerpt: seasonal is an easy-to-use and full-featured R interface to
  X-13ARIMA-SEATS, the seasonal adjustment software developed by the
  United States Census Bureau. The latest CRAN version of seasonal fixes
  several bugs and makes it easier to access output from multiple
  objects.
image: banner.jpg
layout: post
og_image: og_image.jpg
title: "seasonal 1.9: Accessing composite output"
toc-title: Table of contents
---

seasonal is an easy-to-use and full-featured R interface to
X-13ARIMA-SEATS, the seasonal adjustment software developed by the
United States Census Bureau. The latest CRAN version of seasonal fixes
several bugs and makes it easier to access output from multiple objects.
See
[here](https://github.com/christophsax/seasonal/blob/main/NEWS.md#190)
for a complete list of changes.

<figure>
`<img alt="Illustration" src="banner.jpg" style=" width: 100%; height: auto">`{=html}
<figcaption>
Photo by Aaron Burden
</figcaption>
</figure>

`<br>`{=html}

`seas()` is the core function of the
[seasonal](https://cran.r-project.org/package=seasonal) package. By
default, `seas()` calls the automatic procedures of X-13ARIMA-SEATS to
perform a seasonal adjustment that works well in most circumstances:

``` r
library(seasonal)
seas(AirPassengers)
```

For a more detailed introduction, read our [article in the *Journal of
Statistical Software*](https://doi.org/10.18637/jss.v087.i11).

### Multiple series adjustment

The previous version has introduced [the adjustment of multiple
series](https://www.cynkra.com/blog/2021-03-09-seasonal-1.8/) in a
single call to `seas()`. This has removed the need for loops or
`lapply()` in such cases and finally brought the *composite* spec to
seasonal.

As [Brian Monsell](https://github.com/christophsax/seasonal/issues/278)
pointed out, this was not enough to access the output from the composite
spec. The latest [CRAN
version](https://cran.r-project.org/package=seasonal) fixes this
problem.

Multiple adjustments can be performed by supplying multiple time series
as an `"mts"` object:

:::: cell
``` {.r .cell-code}
library(seasonal)
m0 <- seas(cbind(fdeaths, mdeaths), x11 = "")
final(m0)
```

::: {.cell-output .cell-output-stdout}
              fdeaths  mdeaths
    Jan 1974 614.1235 1598.740
    Feb 1974 542.3500 1492.127
    Mar 1974 613.5029 1443.238
    Apr 1974 591.5725 1694.643
    May 1974 607.4970 1696.021
    Jun 1974 543.8415 1558.886
    Jul 1974 597.0745 1663.176
    Aug 1974 587.0533 1623.498
    Sep 1974 588.2693 1741.394
    Oct 1974 735.6666 1735.516
    Nov 1974 602.0218 1665.590
    Dec 1974 496.3985 1394.097
    Jan 1975 564.0055 1560.605
    Feb 1975 591.0320 1708.763
    Mar 1975 585.7739 1652.994
    Apr 1975 581.5294 1671.265
    May 1975 537.8055 1588.605
    Jun 1975 584.3284 1600.979
    Jul 1975 566.4872 1541.099
    Aug 1975 617.1197 1623.445
    Sep 1975 516.4781 1521.497
    Oct 1975 559.0481 1577.200
    Nov 1975 561.6315 1602.659
    Dec 1975 580.9778 1569.692
    Jan 1976 519.8106 1477.855
    Feb 1976 882.3725 2180.616
    Mar 1976 674.5057 1744.114
    Apr 1976 467.4502 1366.628
    May 1976 509.7854 1344.809
    Jun 1976 553.5233 1434.662
    Jul 1976 503.2795 1447.952
    Aug 1976 494.2373 1383.932
    Sep 1976 529.1840 1453.496
    Oct 1976 570.4128 1435.912
    Nov 1976 590.4285 1540.551
    Dec 1976 587.0971 1572.631
    Jan 1977 583.2427 1607.153
    Feb 1977 498.9514 1287.403
    Mar 1977 500.4632 1306.324
    Apr 1977 569.2076 1685.581
    May 1977 565.6470 1405.231
    Jun 1977 509.3196 1432.968
    Jul 1977 548.4062 1414.216
    Aug 1977 523.6985 1444.945
    Sep 1977 563.3014 1402.720
    Oct 1977 495.6653 1427.458
    Nov 1977 453.9859 1307.828
    Dec 1977 502.3045 1268.618
    Jan 1978 535.2658 1415.724
    Feb 1978 633.7605 1790.002
    Mar 1978 559.2936 1469.883
    Apr 1978 485.5062 1343.715
    May 1978 590.4080 1509.166
    Jun 1978 574.4467 1464.288
    Jul 1978 571.2263 1428.398
    Aug 1978 542.3579 1424.622
    Sep 1978 551.2099 1422.428
    Oct 1978 557.6905 1399.404
    Nov 1978 479.8979 1199.762
    Dec 1978 550.4253 1397.023
    Jan 1979 548.9834 1557.853
    Feb 1979 576.9922 1425.717
    Mar 1979 549.3468 1393.788
    Apr 1979 546.4590 1449.784
    May 1979 525.9881 1359.843
    Jun 1979 550.2481 1330.113
    Jul 1979 533.7558 1373.156
    Aug 1979 566.6884 1381.653
    Sep 1979 552.6500 1377.175
    Oct 1979 533.9571 1337.640
    Nov 1979 557.9707 1414.101
    Dec 1979 475.5049 1038.506
:::
::::

This performs two seasonal adjustments, one for `fdeaths` and one for
`mdeaths`. The [vignette on multiple
adjustments](https://cran.r-project.org/web/packages/seasonal/vignettes/multiple.html)
describes how to specify options for individual series.

### Accessing composite output

The `composite` argument is a list with an X-13 specification applied to
the aggregated series:

::: cell
``` {.r .cell-code}
m1 <- seas(
  cbind(mdeaths, fdeaths),
  composite = list(),
  series.comptype = "add"
)
```
:::

With version 1.9 can now use `out()` to access the output of the
composite spec:

``` r
out(m1)
```

We can also use `series()`, e.g., to access the final, indirectly
adjusted series via the `composite` spec (see `?series` for all
available series):

::::: cell
``` {.r .cell-code}
series(m1, "composite.indseasadj")
```

::: {.cell-output .cell-output-stderr}
    To speed up, extend the `seas()` call (see ?series):
    seas(x = cbind(mdeaths, fdeaths), composite = list(), series.comptype = "add", To speed up, extend the `seas()` call (see ?series):
        composite.save = "isa")
:::

::: {.cell-output .cell-output-stdout}
              Jan      Feb      Mar      Apr      May      Jun      Jul      Aug
    1974 2172.614 2053.613 2057.679 2284.821 2260.974 2105.191 2240.895 2185.517
    1975 2098.251 2298.581 2213.878 2256.802 2111.628 2181.738 2098.883 2219.083
    1976 1969.128 3078.359 2373.028 1846.802 1851.167 1983.231 1943.369 1872.025
    1977 2132.860 1807.832 1795.898 2262.793 1957.817 1940.262 1949.784 1953.665
    1978 1908.154 2431.050 2007.252 1830.715 2077.654 2033.120 1987.875 1956.487
    1979 2061.627 1997.557 1925.365 1984.834 1885.778 1882.208 1903.203 1937.474
              Sep      Oct      Nov      Dec
    1974 2296.345 2395.347 2291.835 2013.749
    1975 2024.988 2100.543 2181.495 2234.826
    1976 1967.742 1973.567 2151.597 2199.389
    1977 1946.642 1894.848 1807.119 1808.051
    1978 1959.824 1928.748 1724.336 1966.847
    1979 1925.618 1846.713 1991.679 1517.027
:::
:::::

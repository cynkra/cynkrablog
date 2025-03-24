---
author:
- Christoph Sax
authors:
- Christoph Sax
categories:
- R
- time-series
date: 2021-03-09
excerpt: seasonal is an easy-to-use and full-featured R-interface to
  X-13ARIMA-SEATS, the seasonal adjustment software developed by the
  United States Census Bureau. The latest CRAN version of seasonal makes
  it much easier to adjust multiple time series.
image: banner.jpg
layout: post
og_image: og_image.jpg
title: Seasonal Adjustment of Multiple Series
toc-title: Table of contents
---

seasonal is an easy-to-use and full-featured R-interface to
X-13ARIMA-SEATS, the seasonal adjustment software developed by the
United States Census Bureau. The latest CRAN version of seasonal makes
it much easier to adjust multiple time series.

<figure>
`<img alt="Illustration" src="banner.jpg" style=" width: 100%; height: auto">`{=html}
<figcaption>
Photo by Meriç Dağlı
</figcaption>
</figure>

`<br>`{=html}

[seasonal](http://www.seasonal.website) depends on the
[x13binary](https://CRAN.R-project.org/package=x13binary) package to
access pre-built binaries of X-13ARIMA-SEATS on all platforms and does
not require any manual installation. To install both packages:

``` r
install.packages("seasonal")
```

`seas` is the core function of the
[seasonal](https://cran.r-project.org/package=seasonal) package. By
default, `seas` calls the automatic procedures of X-13ARIMA-SEATS to
perform a seasonal adjustment that works well in most circumstances:

``` r
seas(AirPassengers)
```

For a more detailed introduction, read our [article in the *Journal of
Statistical Software*](https://doi.org/10.18637/jss.v087.i11).

### Multiple Series Adjusmtent

In the latest [CRAN version
1.8](https://cran.r-project.org/package=seasonal), it is now possible to
seasonally adjust multiple series in a single call to `seas()`. This is
done by using the built-in batch mode of X-13. It removes the need for
loops or `lapply()` in such cases and finally brings one missing feature
of X-13 to seasonal -- the *composite* spec.

Multiple adjustments can be performed by supplying multiple time series
as an `"mts"` object:

:::: cell
``` {.r .cell-code}
library(seasonal)
m <- seas(cbind(fdeaths, mdeaths), x11 = "")
final(m)
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

This will perform two seasonal adjustments, one for `fdeaths` and one
for `mdeaths`. X-13 spec-argument combinations can be applied in the
usual way, such as `x11 = ""`. Note that if entered that way, they will
apply to both series. The [vignette on multiple
adjustments](https://cran.r-project.org/web/packages/seasonal/vignettes/multiple.html)
describes how to specify options for individual series.

### Backend

X-13 ships with a batch mode that allows multiple adjustments in a
single call to X-13. This is now the default in seasonal
(`multimode = "x13"`). Alternatively, X-13 can be called for each series
(`multimode = "R"`). The results should be usually the same, but
switching to `multimode = "R"` may be useful for debugging:

::::: cell
``` {.r .cell-code}
seas(cbind(fdeaths, mdeaths), multimode = "x13")
```

::: {.cell-output .cell-output-stdout}
    $fdeaths

    Call:
    seas(x = cbind(fdeaths, mdeaths), multimode = "x13")

    Coefficients:
          Constant      AO1976.Feb  MA-Seasonal-12  
          -0.01578         0.43345         0.63119  


    $mdeaths

    Call:
    seas(x = cbind(fdeaths, mdeaths), multimode = "x13")

    Coefficients:
           AO1976.Feb         LS1976.Apr         AO1977.Apr         AO1978.Feb  
               0.3319            -0.1330             0.1957             0.2305  
           AO1979.Dec  MA-Nonseasonal-01     MA-Seasonal-12  
              -0.3149            -0.3854             0.6120  


    $call
    seas(x = cbind(fdeaths, mdeaths), multimode = "x13")

    attr(,"class")
    [1] "seas_multi" "list"      
:::

``` {.r .cell-code}
seas(cbind(fdeaths, mdeaths), multimode = "R")
```

::: {.cell-output .cell-output-stdout}
    $fdeaths

    Call:
    seas(x = cbind(fdeaths, mdeaths), multimode = "R")

    Coefficients:
          Constant      AO1976.Feb  MA-Seasonal-12  
          -0.01578         0.43345         0.63119  


    $mdeaths

    Call:
    seas(x = cbind(fdeaths, mdeaths), multimode = "R")

    Coefficients:
           AO1976.Feb         LS1976.Apr         AO1977.Apr         AO1978.Feb  
               0.3319            -0.1330             0.1957             0.2305  
           AO1979.Dec  MA-Nonseasonal-01     MA-Seasonal-12  
              -0.3149            -0.3854             0.6120  


    $call
    seas(x = cbind(fdeaths, mdeaths), multimode = "R")

    attr(,"class")
    [1] "seas_multi" "list"      
:::
:::::

In general, `multimode = "x13"` is faster. The following comparison on a
MacBook Pro shows a modest speed gain, but bigger differences have been
observed on other systems:

``` r
many <- rep(list(fdeaths), 100)
system.time(seas(many, multimode = "x13"))
#   user  system elapsed
#  9.415   0.653  10.079
system.time(seas(many, multimode = "R"))
#   user  system elapsed
# 11.130   1.039  12.324
```

### composite spec

Support for the X-13 batch mode makes it finally possible to use the
*composite* spec -- the one feature of X-13 that was missing in
seasonal. Sometimes, one has to decide whether seasonal adjustment
should be performed on a granular level or on an aggregated level. The
*composite* spec helps you to analyze the problem and to compare the
direct and the indirect adjustments.

The `composite` argument is a list with an X-13 specification that is
applied on the aggregated series. Specification works identically for
other series in `seas()`, including the application of the defaults. If
you provide an empty list, the usual defaults of `seas()` are used. A
minimal composite call looks like this:

:::: cell
``` {.r .cell-code}
seas(
  cbind(mdeaths, fdeaths),
  composite = list(),
  series.comptype = "add"
)
```

::: {.cell-output .cell-output-stdout}
    $mdeaths

    Call:
    seas(x = cbind(mdeaths, fdeaths), composite = list(), series.comptype = "add")

    Coefficients:
           AO1976.Feb         LS1976.Apr         AO1977.Apr         AO1978.Feb  
               0.3319            -0.1330             0.1957             0.2305  
           AO1979.Dec  MA-Nonseasonal-01     MA-Seasonal-12  
              -0.3149            -0.3854             0.6120  


    $fdeaths

    Call:
    seas(x = cbind(mdeaths, fdeaths), composite = list(), series.comptype = "add")

    Coefficients:
          Constant      AO1976.Feb  MA-Seasonal-12  
          -0.01578         0.43345         0.63119  


    $composite

    Call:
    seas(x = cbind(mdeaths, fdeaths), composite = list(), series.comptype = "add")

    Coefficients:
             Constant         AO1976.Feb  MA-Nonseasonal-01     MA-Seasonal-12  
             -0.03133            0.31247           -0.43509            0.99937  


    $call
    seas(x = cbind(mdeaths, fdeaths), composite = list(), series.comptype = "add")

    attr(,"class")
    [1] "seas_multi" "list"      
:::
::::

You can verify that the composite refers to the total of `mdeaths` and
`fdeaths` by running:

:::: cell
``` {.r .cell-code}
seas(ldeaths)
```

::: {.cell-output .cell-output-stdout}

    Call:
    seas(x = ldeaths)

    Coefficients:
             Constant         AO1976.Feb  MA-Nonseasonal-01     MA-Seasonal-12  
             -0.03133            0.31247           -0.43509            0.99937  
:::
::::

where `ldeaths` is the sum of `mdeaths` and `fdeaths`.

### Acknowledgement

Many thanks to [Severin
Thöni](https://mtec.ethz.ch/people/person-detail.MTU3MzEx.TGlzdC8yODk2LC0yMDgyMjgwMDQ4.html)
and [Matthias
Bannert](https://kof.ethz.ch/das-institut/personen/person-detail.MTYxMjA1.TGlzdC81NzgsODQ4OTAwOTg=.html),
for demonstrating the benefits of the X-13 batch mode. Also to the [ETH
KOF](https://kof.ethz.ch), for partially funding this development.

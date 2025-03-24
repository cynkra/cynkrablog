---
author:
- David Granjon
authors:
- David Granjon
categories:
- R
- Shiny
date: 2024-09-16
header-includes:
- |
  <script  src="index_files/libs/quarto-diagram/mermaid-postprocess-shim.js"></script>
image: "https://avatars.githubusercontent.com/u/145758851?s=400&u=1545a34095e8e84f5cb2b292b1e900df59ba7239&v=4"
layout: post
title: "Introducing blockr: a no-code dashboard builder for R"
toc-title: Table of contents
---

<script  src="index_files/libs/quarto-diagram/mermaid-postprocess-shim.js"></script>

![](https://avatars.githubusercontent.com/u/145758851?s=400&u=1545a34095e8e84f5cb2b292b1e900df59ba7239&v=4.png){width="25%"
fig-align="center"}

Since 2023, [BristolMyersSquibb](https://www.bms.com/), the Y
[company](https://the-y-company.com/) and [cynkra](https://cynkra.com)
have teamed up to develop a novel **no-code** solution for R.

::::: {.cell warnings="false" messages="false"}
``` {.r .cell-code}
library(blockr)
```

::: {.cell-output .cell-output-stderr}

    Attaching package: 'blockr'
:::

::: {.cell-output .cell-output-stderr}
    The following object is masked from 'package:graphics':

        layout
:::

``` {.r .cell-code}
library(pracma)
library(shiny)
```
:::::

## Introduction

blockr is an R package designed to democratize **data analysis** by
providing a **flexible**, **intuitive**, and **code-free** approach to
building data pipelines. It has 2 main user targets:

1.  On the one hand, it empowers **non technical** users to create
    insightful data workflows using **pre-built** blocks that can be
    easily connected, all without writing a single line of code.
2.  On the other hand, it provides developers with a set of tools to
    seamlessly create new blocks, thereby enhancing the entire framework
    and fostering **collaboration** within organizations teams.

blockr is data **agnostic**, meaning it can work with any kind of
dataset, that is pharmaceutical data or sport analytics data. It builds
on top of [shiny](https://shiny.posit.co/) to ensure real time feedback
to any data change. Finally, it allows to export code to create
**reproducible** data analysis.

## Getting started

### As a simple user

As a simple user, you're not expected to write any single line of code
to use blockr. You can use the below kitchen sink to get started. This
example is based on the palmer penguins data and running a single stack
with 3 blocks: the first block to select the data, another one to create
the plot and then add the points to it.

blockr has a its own **validation** system. For instance, using the
below example, you can try to press return on the first block select box
(penguins is the selected default). You'll notice an immediate feedback
message. A global message is displayed in the block upper middle part:
"1 error(s) found in this block". You get more detailed mesages next to
the faulty input(s): "selected value(s) not among provided choices". You
can repeat the same experience with the last plot layer block, by
emptying the color and shape select inputs. Error messages can
accumulate.

You can dynamically add blocks to a current **stack**, that gathers a
set of related blocks. You can think a stack as a data analysis
**recipe** as in cooking, where blocks are instructions. To add a new
block, you can click on the `+` icon on the stack top right corner. This
opens a sidebar on the left side, where one may search for blocks that
are compatible with the current state of the pipeline. With an empty
stack, only entry point blocks are suggested, so you can import data.
Then, after clicking on the block, the suggestion list changes so you
can, for instance, filter data or select only a subset of columns, and
much more.

::: cell
``` {.r .cell-code}
library(blockr)
library(palmerpenguins)
library(ggplot2)

new_ggplot_block <- function(col_x = character(), col_y = character(), ...) {
  data_cols <- function(data) colnames(data)

  new_block(
    fields = list(
      x = new_select_field(col_x, data_cols, type = "name"),
      y = new_select_field(col_y, data_cols, type = "name")
    ),
    expr = quote(
      ggplot(mapping = aes(x = .(x), y = .(y)))
    ),
    class = c("ggplot_block", "plot_block"),
    ...
  )
}

new_geompoint_block <- function(color = character(), shape = character(), ...) {
  data_cols <- function(data) colnames(data$data)

  new_block(
    fields = list(
      color = new_select_field(color, data_cols, type = "name"),
      shape = new_select_field(shape, data_cols, type = "name")
    ),
    expr = quote(
      geom_point(aes(color = .(color), shape = .(shape)), size = 2)
    ),
    class = c("geompoint_block", "plot_layer_block", "plot_block"),
    ...
  )
}

stack <- new_stack(
  data_block = new_dataset_block("penguins", "palmerpenguins"),
  plot_block = new_ggplot_block("flipper_length_mm", "body_mass_g"),
  layer_block = new_geompoint_block("species", "species")
)
serve_stack(stack)
```
:::

::::: column-page
:::: cell
::: cell-output-display
<iframe class="border border-5 rounded shadow-lg" src="https://shinylive.io/r/app/#h=0&amp;code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAdzgCMAnRRASwgGdSoAbbgCgA6YOtyIEA1gyG4ABAzioi7GQF4ZBQWAAWpUqnaIA9IcYtORbjACecBu3YBHAK4s6dDAHMWpLU-csiQ1pGAFp5RXZpGSEdPQNjcKIMBhDqKHYYDCIGDyEASjyBCG5XBigGKz4RMUlC4tLyytQeeAZUCg8XDjqSxka+Dw9UUVIAJjqiiDhqAH1B4aJSGeqJGQAeEJkAMycIAlIAiD5ibhmAD1V1LXKofds+PNkTmatLgmuyu4YH2Qw-vJkICKMhkABMoFwZidlBttrt9oc+OCuACTtB4OwkRCoBMICCprMVuJBHiQdsWHBuKDlGoSpwSWSyRc1ASZuxKXB9jMthSqccLOdZMioFCLOxZKQrO1LkJ0XB8rhgYyZK8WdM2RyuTzKaD+acrELsaLuOKZJLpWpZbB5WA6ozHkqQXAzqgGJdnIs4AzlfMRnwYGhUGwPJcoHBMcyZBg+GdHirLtGrAU7WSHaSQQRuOkaepNL7FstRBIokIFksiQrHVG-kq6gBfIqTdUeOBEGCKNjlovidabHZ7A4kPXZN4fW7kb5x9jXC1XG5fH7VjAAoGk4XGmF9+GDo7C1EWOWY4UAEj3jdJrKJ3pB2qpObppGvZJOI7Vs3Z3E5S1vupfDENkLQhKUpwDKkDWpW6ZktOaCgW+GqflqvK6jB7QASKQFmiBYFyvkVZpoyzquu6Tiek+IItm2MwdmQfBhpif4JsODBTjOcFRnwqFwAUsjsCwABe7HjPhipQZm2ZvHmrbtkQnaFjUJZgGWMxZjYDDycWeDREpIwaeIkGMn8GC1kUDYQEUnC3D2sKspZEjeuuRKXKywrsl2NSaO0ECdGwkRaaWLS2F5PkcAZMjKU58H5u59lCFsJToLYKkdD4MwwDAil0EQoJWGl2ZzGFqlJZFMispRMlyVeQjsO0BAUn5sjVbV9V4RAdTsgwABucBslw9l2eIeRgHWAC6QA" width="100%" height="800px"></iframe>
:::
::::
:::::

#### Toward more complex analysis

Let's consider this
[dataset](https://www.kaggle.com/datasets/heesoo37/120-years-of-olympic-history-athletes-and-results?select=athlete_events.csv),
which contains 120 years of olympics athletes data until Rio in 2016. In
the below kitchen sink, we first add an upload block:

1.  Download the
    [dataset](https://www.kaggle.com/datasets/heesoo37/120-years-of-olympic-history-athletes-and-results?select=athlete_events.csv)
    file locally.
2.  CLick on `Add stack`.
3.  Click on the stack `+` button and search for `browser`, then select
    the `new_filesbrowser_block`.
4.  Uncollapse the stack by click on the top right arrow icon. This
    makes the upload block file input visible.
5.  Click on `File select` and select the downloaded file at step 1
    (`athlete_events.csv`).
6.  As we obtain a csv file, we must parse it with a `new_csv_block`.
    Repeat step 3 to add the `new_csv_block`. The table is `271116` rows
    and `15` columns.
7.  Add a `new_filter_block` and select `Sex` as column and then `F` in
    the values input. We leave the comparison to `==` and click on the
    `Run` button. Notice we now have 74522 rows.
8.  Add a `new_mutate_block` with the following expression:
    `birth_year = Year - Age` (this gives us an approximate birth year).
    Click on submit.

From now on, we leave the first stack as is and will reuse it in other
stacks. We want to display the average height distribution for female
athletes. Let's do it below.

9.  Create a new stack by clicking on `Add stack`.
10. Add it a `new_result_block`. This allows to import the data from the
    first stack (and potentially any stack from the dashboard). If you
    don't see any data, select another stack name from the dropdown
    menu.
11. Add a `new_ggplot_block`, leave `x` as default function and select
    `Height` as variable in the columns input.
12. Add a `new_geomhistogram_block`. Now we have our distribution plot.

Alternatively, you could remove the 2 plot blocks and add a
`new_summarize_block` using `mean` as function and `Height` as column
(result: 168 cm).

In the following, we create a look-up table to be able to retrieve the
athlete names based on their `ID`.

13. Create a new stack.
14. Add a result block to import data from the very first stack.
15. Add a `new_select_block` and only select `ID`, `Name`, `birth_year`,
    `Team` and `Sport` as columns.

Our goal is now to find which athlete did 2 or more different sports.

16. Create a new stack.
17. Add a result block to import data from the very first stack.
18. Add a `new_filter_block` , select `Medal` as column, `!=` as
    comparison operator and leave the value empty. Click on run, which
    will only get athletes with medals.
19. Add a `new_group_by_block`, grouping by `ID` (as some athletes have
    the same name).
20. Add a `new_summarize_block` by choising the function `n_distinct`
    applied on the `Sport` columns.
21. Add a `new_filter_block` , select `N_DISTINCT` as column, `>=` as
    comparison operator and set the value to 2. Click on run. This gives
    us the athletes that are doing 2 sports or more.
22. Add a `new_join_block`. Select `left_join` as join function, select
    the third stack (lookup table) as join table and `ID` as column.
23. Add a `new_arrange_block` for the `birth_year` column.

As a conclusion, Hjrdis Viktoria Tpel (1904) was the first recorded
athlete to compete in 2 different sports, swimming and diving for
Sweden. Lauryn Chenet Williams (1984) is the latest for US with
Athletics and Bobsleigh. It's actually quite amazing to see people
competing in two quite unrelated sports like swimming and handbain the
case of Roswitha Krause.

::: cell
``` {.r .cell-code}
library(blockr)
library(blockr.ggplot2)

options(shiny.maxRequestSize = 100 * 1024^2)
do.call(set_workspace, args = list(title = "My workspace"))
serve_workspace(clear = FALSE)
```
:::

::::: column-screen-inset
:::: cell
::: cell-output-display
<iframe class="border border-5 rounded shadow-lg" src="https://shinylive.io/r/app/#h=0&amp;code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAdzgCMAnRRASwgGdSoAbbgCgA6YOtyIEA1gyG4ABAzioi7GQF4ZBQWAAWpUqnaIA9IcYtORbjACecBu3YBHAK4s6dDAHMWpLU-csiQ1pGAFp5RXZpGSEdPQNjcKIMBhDqKHYYDCIGDyEASjyBCGCmVg4uXk0RMUlPD1RRUgAmKMTlNRjdfSMTBjNSC2tbe2dXdy8fPwwAoPoUtvyi7lcGKAYrPg8uEThCiGXGNY32Ah44dj2D1fW+aokGS5Wj29F7uoaiZr2iolRSAI4fHYWjYVgwMCgAA8sHBnOdSABlFgALzgqhkAEYAAxYmQAKkxWKaABYAHpNPYAEySp0q7DgpAA+tRsuJ2KgoAQ4LI1h52jJlpw+P9SNw0R0wABZKwyFkMNkcrn5Pb0hgANzgzNZ7M5cD4BDFa3RADEAIIAGQRAFE8mAAL4AXSAA" width="100%" height="800px"></iframe>
:::
::::
:::::

As an end-user, you are not supposed to write code. As such, if you
think anything is missing, you can open an issue
[here](https://github.com/BristolMyersSquibb/blockr/issues), or ask any
developer you are working with to create new blocks. This leads us to
the second part of this blog post ... How to use blockr as a developers?

### As a developer

How to install it:

``` r
pak::pak("BristolMyersSquibb/blockr")
```

blockr can't provide any single data manipulation or visualization
block. That's the reason why we made it easily **extensible**. You can
get an introduction to blockr for developers
[here](https://bristolmyerssquibb.github.io/blockr/articles/blockr.html#blockr-for-developers).

In the following, we create an ordinary differential equations solver
block using the pracma package. We choose the Lorenz
[attractor](https://en.wikipedia.org/wiki/Lorenz_system). With R,
equations may be written as:

``` r
lorenz <- function(t, y, parms) {
  c(
    X = parms[1] * y[1] + y[2] * y[3],
    Y = parms[2] * (y[2] - y[3]),
    Z = -y[1] * y[2] + parms[3] * y[2] - y[3]
  )
}
```

where `t` is the time, `y` a vector of solutions and `params` the
various parameters. If you are familiar with
[deSolve](https://cran.r-project.org/web/packages/deSolve/index.html),
equations are defined with similar functions. For this blog post, we
selected pracma as deSolve does not run in shinylive, so you could not
see the embedded demonstration.

### Add interactivity with the **fields**

We want to add interactivity on the 3 different parameters. Hence, we
create our new block function with 3 **fields** inside a list. Since the
expected values are numbers, we leverage the `new_numeric_field`.
Parameters are only explicitly shown for the first field:

``` r
new_ode_block <- function(...) {
  fields <- list(
    a = new_numeric_field(value = -8 / 3, min = -10, max = 20),
    b = new_numeric_field(-10, -50, 100),
    c = new_numeric_field(28, 1, 100)
  )
  # TBD
  # ...
}
```

As you may imagine, these fields are subsequently translated into shiny
inputs, that is `numericInput` in our example. If you face a situation
where you need to implement a custom field, not included in blockr, you
can read this
[vignette](https://bristolmyerssquibb.github.io/blockr/articles/new-field.html).

### Create the block expression

As next step, we **instantiate** our block with the `new_block` blockr
**constructor**:

``` r
new_block(
  fields = fields,
  expr = quote(<EXPR>),
  ...,
  class = <CLASSES>,
  submit = FALSE
)
```

A block is composed of fields, a quoted **expression** which involved
fields (to delay the evaluation), somes **classes** which control the
block behavior, and extra parameters passed with `...`. Finally,
`submit` allows to delay the block evaluation by requiring the user to
click on a submit button (FALSE by default). This prevents from
triggering unwanted intensive computations.

In our example, the expression calls the `ode45` function. Notice the
usage of `substitute` to inject the `lorenz` function within the
expression. This is necessary since `lorenz` is defined outside of the
expression, and using `quote` would fail. Fields are invoked with
`.(field_name)`, a rather strange notation, required by `bquote` to
process the expression. It is not mandory to understand this technical
underlying detail, but this standard must be respected. You may also
notice that some parameters like the initial conditions `y0` or time
values are hardcoded. We leave the reader to transform them into fields,
as an exercise:

``` r
new_block(
  fields = fields,
  expr = substitute(
    as.data.frame(
      ode45(
        fun,
        y0 = c(X = 1, Y = 1, Z = 1),
        t0 = 0,
        tfinal = 100,
        parms = c(.(a), .(b), .(c))
      )
    ),
    list(fun = lorenz)
  )
  # TBD
)
```

### Add the right classes

We give our block 2 classes, namely `ode_block` and `data_block`:

::: cell
``` {.r .cell-code}
new_ode_block <- function(...) {
  fields <- list(
    a = new_numeric_field(-8 / 3, -10, 20),
    b = new_numeric_field(-10, -50, 100),
    c = new_numeric_field(28, 1, 100)
  )

  new_block(
    fields = fields,
    expr = substitute(
      as.data.frame(
        ode45(
          fun,
          y0 = c(X = 1, Y = 1, Z = 1),
          t0 = 0,
          tfinal = 100,
          parms = c(.(a), .(b), .(c))
        )
      ),
      list(fun = lorenz)
    ),
    ...,
    class = c("ode_block", "data_block")
  )
}
```
:::

As explained earlier, they are required to control the block behavior,
as blockr is build with [S3](https://adv-r.hadley.nz/s3.html). For
instance, `data_block` have a specific **evaluation** method, to
calculate the expression:

``` r
evaluate_block.data_block <- function (x, ...) 
{
  stopifnot(...length() == 0L)
  eval(generate_code(x), new.env())
}
```

where `generate_code` processes the block code. **Data** blocks are
considered as entry point blocks, as opposed to **transformation**
blocks, that operate on data. Therefore, you may easily understand that
the evaluation method for a transform block requires to pass the data
from the previous block with `%>%`:

``` r
evaluate_block.block <- function (x, data, ...) 
{
  stopifnot(...length() == 0L)
  eval(substitute(data %>% expr, list(expr = generate_code(x))), list(data = data))
}
```

If you want to build a plot block and plot layers blocks, you would have
to design a specific evaluate method, that accounts for the `+` operator
required by ggplot2. To learn more about how to create a plot block, you
can read this
[article](https://bristolmyerssquibb.github.io/blockr/articles/plot-block.html).

### Demo

::: cell
``` {.r .cell-code}
library(blockr)
library(pracma)
library(blockr.ggplot2)

lorenz <- function(t, y, parms) {
  c(
    X = parms[1] * y[1] + y[2] * y[3],
    Y = parms[2] * (y[2] - y[3]),
    Z = -y[1] * y[2] + parms[3] * y[2] - y[3]
  )
}

new_ode_block <- function(...) {
  fields <- list(
    a = new_numeric_field(-8 / 3, -10, 20),
    b = new_numeric_field(-10, -50, 100),
    c = new_numeric_field(28, 1, 100)
  )

  new_block(
    fields = fields,
    expr = substitute(
      as.data.frame(
        ode45(
          fun,
          y0 = c(X = 1, Y = 1, Z = 1),
          t0 = 0,
          tfinal = 100,
          parms = c(.(a), .(b), .(c))
        )
      ),
      list(fun = lorenz)
    ),
    ...,
    class = c("ode_block", "data_block")
  )
}

stack <- new_stack(
  new_ode_block,
  new_ggplot_block(
    func = c("x", "y"),
    default_columns = c("y.1", "y.2")
  ),
  new_geompoint_block
)
serve_stack(stack)
```
:::

::::: column-screen-inset
:::: cell
::: cell-output-display
<iframe class="border border-5 rounded shadow-lg" src="https://shinylive.io/r/editor/#code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAdzgCMAnRRASwgGdSoAbbgCgA6YOtyIEA1gyG4ABAzioi7GQF4ZBQWAAWpUqnaIA9IcYtORbjACecBu3YBHAK4s6dDAHMWpLU-csiQ1pGAFp5RXZpGSEdPQNjcKIMBhDqKHYYDCIGDyEASjyBCGCmVg4uXk0RMUlPD1RRUgAmKMTlNRjdfSMTBjNSC2tbe2dXdy8fPwwAoPoUtvyi7lcGKAYrPg8uEThCiGXGNY32Ah44dj2D1fW+aokGS5WjvlRVghgoR8Obu9qPesaTT2S2yFAAXjIADwhGQAMycEAIpACED4pFkVlkqDWMAuMhARRk6kEECJRIAGqoZNiGLjgABGAC6MgAVDIrAzmQBqdnAJrMtkcgDMjNwhLJAE0qTS6fzWTI+By5TDhYy8mLSWSAFpUkIcpnypXc6k49jAEWGvnMlXmxnivYAXyKRQgcGoAH0iAATODu35QmHwxHIkh8DDhvL48Wwlhwbhe5TQmTLTgkskyKBU10eiBOeB9AjumNxr18EIADhkhhkQtkIXpAAZZE0G+rxUS6Fm3e7c-mWIXi-Gy426wBWJsyRutjXpghdnN52z9ouxodNcuyembhut+3OzXZv2iCRpsmDhNU8-sGdkuAAD1eVPYfk43ic5FP6fSGC9UC4GFhVZ4E-dMZG9OAABZRxA0C4QRG9YKJKwGypDRKTULcZClDDZB1DC201RCZFIFC1CbdtENIGNoG4KkpwQxCZXaYkMD4T5ZFYuh1RkViCAKCj0z2WCCNglNSD4IMqVEeQIDBISyREslwwwBiCG4dJmI0IRwKPGooiEX8uF0iRFk1R1904KAJADGRD0sk9xUPHTfhvQ9-gaIhSGM8QQKDOc1C0sA730sArHyBifVhKAnG4LziG4PMOFQzQrAwekQtSlowHkxS3LgIgYEUNgvN+Io9nYWwADdfXsnzaryMAHUZIA" width="100%" height="800px"></iframe>
:::
::::
:::::

### Packaging new blocks: the registry

In the above example, we define the block on the fly. However, an other
outstanding feature of blockr is the **registry**, which you can see as
a blocks **supermarket**. From the R side, the registry is an
**environment** that can be extended by developers who bring their own
blocks packages:

::::::::::::::::::::: {.cell mermaid-theme="default" layout-align="default"}
:::::::::::::::::::: cell-output-display
<div>

`<figure class=''>`{=html}

<div>

<svg aria-roledescription="flowchart-v2" role="graphics-document document" viewbox="0 0 1105.03125 922" class="flowchart" xlink="http://www.w3.org/1999/xlink" xmlns="http://www.w3.org/2000/svg" width="672" id="mermaid-figure-1" height="480">
<style>#mermaid-figure-1{font-family:"trebuchet ms",verdana,arial,sans-serif;font-size:16px;fill:#333;}#mermaid-figure-1 .error-icon{fill:#552222;}#mermaid-figure-1 .error-text{fill:#552222;stroke:#552222;}#mermaid-figure-1 .edge-thickness-normal{stroke-width:1px;}#mermaid-figure-1 .edge-thickness-thick{stroke-width:3.5px;}#mermaid-figure-1 .edge-pattern-solid{stroke-dasharray:0;}#mermaid-figure-1 .edge-thickness-invisible{stroke-width:0;fill:none;}#mermaid-figure-1 .edge-pattern-dashed{stroke-dasharray:3;}#mermaid-figure-1 .edge-pattern-dotted{stroke-dasharray:2;}#mermaid-figure-1 .marker{fill:#333333;stroke:#333333;}#mermaid-figure-1 .marker.cross{stroke:#333333;}#mermaid-figure-1 svg{font-family:"trebuchet ms",verdana,arial,sans-serif;font-size:16px;}#mermaid-figure-1 p{margin:0;}#mermaid-figure-1 .label{font-family:"trebuchet ms",verdana,arial,sans-serif;color:#333;}#mermaid-figure-1 .cluster-label text{fill:#333;}#mermaid-figure-1 .cluster-label span{color:#333;}#mermaid-figure-1 .cluster-label span p{background-color:transparent;}#mermaid-figure-1 .label text,#mermaid-figure-1 span{fill:#333;color:#333;}#mermaid-figure-1 .node rect,#mermaid-figure-1 .node circle,#mermaid-figure-1 .node ellipse,#mermaid-figure-1 .node polygon,#mermaid-figure-1 .node path{fill:#ECECFF;stroke:#9370DB;stroke-width:1px;}#mermaid-figure-1 .rough-node .label text,#mermaid-figure-1 .node .label text{text-anchor:middle;}#mermaid-figure-1 .node .katex path{fill:#000;stroke:#000;stroke-width:1px;}#mermaid-figure-1 .node .label{text-align:center;}#mermaid-figure-1 .node.clickable{cursor:pointer;}#mermaid-figure-1 .arrowheadPath{fill:#333333;}#mermaid-figure-1 .edgePath .path{stroke:#333333;stroke-width:2.0px;}#mermaid-figure-1 .flowchart-link{stroke:#333333;fill:none;}#mermaid-figure-1 .edgeLabel{background-color:rgba(232,232,232, 0.8);text-align:center;}#mermaid-figure-1 .edgeLabel p{background-color:rgba(232,232,232, 0.8);}#mermaid-figure-1 .edgeLabel rect{opacity:0.5;background-color:rgba(232,232,232, 0.8);fill:rgba(232,232,232, 0.8);}#mermaid-figure-1 .labelBkg{background-color:rgba(232, 232, 232, 0.5);}#mermaid-figure-1 .cluster rect{fill:#ffffde;stroke:#aaaa33;stroke-width:1px;}#mermaid-figure-1 .cluster text{fill:#333;}#mermaid-figure-1 .cluster span{color:#333;}#mermaid-figure-1 div.mermaidTooltip{position:absolute;text-align:center;max-width:200px;padding:2px;font-family:"trebuchet ms",verdana,arial,sans-serif;font-size:12px;background:hsl(80, 100%, 96.2745098039%);border:1px solid #aaaa33;border-radius:2px;pointer-events:none;z-index:100;}#mermaid-figure-1 .flowchartTitleText{text-anchor:middle;font-size:18px;fill:#333;}#mermaid-figure-1 :root{--mermaid-font-family:"trebuchet ms",verdana,arial,sans-serif;}</style>
`<g><marker orient="auto" markerheight="8" markerwidth="8" markerunits="userSpaceOnUse" refy="5" refx="5" viewbox="0 0 10 10" class="marker flowchart-v2" id="mermaid-1742851153932_flowchart-v2-pointEnd"><path style="stroke-width: 1; stroke-dasharray: 1, 0;" class="arrowMarkerPath" d="M 0 0 L 10 5 L 0 10 z"></path></marker><marker orient="auto" markerheight="8" markerwidth="8" markerunits="userSpaceOnUse" refy="5" refx="4.5" viewbox="0 0 10 10" class="marker flowchart-v2" id="mermaid-1742851153932_flowchart-v2-pointStart"><path style="stroke-width: 1; stroke-dasharray: 1, 0;" class="arrowMarkerPath" d="M 0 5 L 10 10 L 10 0 z"></path></marker><marker orient="auto" markerheight="11" markerwidth="11" markerunits="userSpaceOnUse" refy="5" refx="11" viewbox="0 0 10 10" class="marker flowchart-v2" id="mermaid-1742851153932_flowchart-v2-circleEnd"><circle style="stroke-width: 1; stroke-dasharray: 1, 0;" class="arrowMarkerPath" r="5" cy="5" cx="5"></circle></marker><marker orient="auto" markerheight="11" markerwidth="11" markerunits="userSpaceOnUse" refy="5" refx="-1" viewbox="0 0 10 10" class="marker flowchart-v2" id="mermaid-1742851153932_flowchart-v2-circleStart"><circle style="stroke-width: 1; stroke-dasharray: 1, 0;" class="arrowMarkerPath" r="5" cy="5" cx="5"></circle></marker><marker orient="auto" markerheight="11" markerwidth="11" markerunits="userSpaceOnUse" refy="5.2" refx="12" viewbox="0 0 11 11" class="marker cross flowchart-v2" id="mermaid-1742851153932_flowchart-v2-crossEnd"><path style="stroke-width: 2; stroke-dasharray: 1, 0;" class="arrowMarkerPath" d="M 1,1 l 9,9 M 10,1 l -9,9"></path></marker><marker orient="auto" markerheight="11" markerwidth="11" markerunits="userSpaceOnUse" refy="5.2" refx="-1" viewbox="0 0 11 11" class="marker cross flowchart-v2" id="mermaid-1742851153932_flowchart-v2-crossStart"><path style="stroke-width: 2; stroke-dasharray: 1, 0;" class="arrowMarkerPath" d="M 1,1 l 9,9 M 10,1 l -9,9"></path></marker><g class="root"><g class="clusters"></g><g class="edgePaths"><path marker-end="url(#mermaid-1742851153932_flowchart-v2-pointEnd)" style="" class="edge-thickness-normal edge-pattern-solid edge-thickness-normal edge-pattern-solid flowchart-link" id="L_blockr_custom_registry_0" d="M422.172,461L430.947,461C439.723,461,457.273,461,470.437,461C483.6,461,492.375,461,500.484,461C508.592,461,516.035,461,519.756,461L523.477,461"></path></g><g class="edgeLabels"><g transform="translate(474.82421875, 461)" class="edgeLabel"><g transform="translate(-27.65234375, -12)" class="label"><foreignobject height="24" width="55.3046875">`{=html}

::: {.labelBkg style="display: table-cell; white-space: nowrap; line-height: 1.5; max-width: 200px; text-align: center;" xmlns="http://www.w3.org/1999/xhtml"}
`<span class="edgeLabel">`{=html}
<p>
register
</p>
`</span>`{=html}
:::

`</foreignobject></g></g></g><g class="nodes"><g transform="translate(519.4765625, 0)" class="root"><g class="clusters"><g data-look="classic" id="registry" class="cluster"><rect height="906" width="569.5546875" y="8" x="8" style=""></rect><g transform="translate(264.3203125, 8)" class="cluster-label"><foreignobject height="24" width="56.9140625">`{=html}

::: {style="display: table-cell; white-space: nowrap; line-height: 1.5; max-width: 200px; text-align: center;" xmlns="http://www.w3.org/1999/xhtml"}
`<span class="nodeLabel">`{=html}
<p>
Registry
</p>
`</span>`{=html}
:::

`</foreignobject></g></g></g><g class="edgePaths"><path marker-end="url(#mermaid-1742851153932_flowchart-v2-crossEnd)" style="" class="edge-thickness-normal edge-pattern-solid edge-thickness-normal edge-pattern-solid flowchart-link" id="L_filter_reg_trash_1" d="M100,85.5L100,93.75C100,102,100,118.5,100,157.458C100,196.417,100,257.833,100,319.25C100,380.667,100,442.083,100,472.792L100,503.5"></path></g><g class="edgeLabels"><g transform="translate(100, 135)" class="edgeLabel"><g transform="translate(-36.39453125, -12)" class="label"><foreignobject height="24" width="72.7890625">`{=html}

::: {.labelBkg style="display: table-cell; white-space: nowrap; line-height: 1.5; max-width: 200px; text-align: center;" xmlns="http://www.w3.org/1999/xhtml"}
`<span class="edgeLabel">`{=html}
<p>
unregister
</p>
`</span>`{=html}
:::

`</foreignobject></g></g></g><g class="nodes"><g transform="translate(100, 65.5)" id="filter_reg" class="node"><rect height="40" width="114" y="-20" x="-57" data-et="node" data-id="abc" style="" class="basic label-container"></rect><g transform="translate(-41, -12)" style="" class="label"><rect></rect><foreignobject height="24" width="82">`{=html}

::: {style="display: table-cell; white-space: nowrap; line-height: 1.5; max-width: 200px; text-align: center;" xmlns="http://www.w3.org/1999/xhtml"}
`<span class="nodeLabel">`{=html}
<p>
Filter block
</p>
`</span>`{=html}
:::

`</foreignobject></g></g><g transform="translate(100, 530.5)" id="flowchart-trash-11" class="node default"><rect height="54" width="65.109375" y="-27" x="-32.5546875" data-et="node" data-id="abc" style="" class="basic label-container"></rect><g transform="translate(-2.5546875, -12)" style="" class="label"><rect></rect><foreignobject height="24" width="5.109375">`{=html}

::: {style="display: table-cell; white-space: nowrap; line-height: 1.5; max-width: 200px; text-align: center;" xmlns="http://www.w3.org/1999/xhtml"}
`<span class="nodeLabel">`{=html}
<p>
'`<i class="fa fa-trash"></i>`{=html}'
</p>
`</span>`{=html}
:::

`</foreignobject></g></g><g transform="translate(174.5546875, 176.5)" class="root"><g class="clusters"><g data-look="classic" id="select_reg" class="cluster"><rect height="692" width="360" y="8" x="8" style=""></rect><g transform="translate(144.41796875, 8)" class="cluster-label"><foreignobject height="24" width="87.1640625">`{=html}

::: {style="display: table-cell; white-space: nowrap; line-height: 1.5; max-width: 200px; text-align: center;" xmlns="http://www.w3.org/1999/xhtml"}
`<span class="nodeLabel">`{=html}
<p>
Select block
</p>
`</span>`{=html}
:::

`</foreignobject></g></g></g><g class="edgePaths"></g><g class="edgeLabels"></g><g class="nodes"><g transform="translate(188, 70)" id="flowchart-reg_name-4" class="node default"><rect height="54" width="197.265625" y="-27" x="-98.6328125" data-et="node" data-id="abc" style="" class="basic label-container"></rect><g transform="translate(-68.6328125, -12)" style="" class="label"><rect></rect><foreignobject height="24" width="137.265625">`{=html}

::: {style="display: table-cell; white-space: nowrap; line-height: 1.5; max-width: 200px; text-align: center;" xmlns="http://www.w3.org/1999/xhtml"}
`<span class="nodeLabel">`{=html}
<p>
Name: select block
</p>
`</span>`{=html}
:::

`</foreignobject></g></g><g transform="translate(188, 186)" id="flowchart-reg_descr-5" class="node default"><rect height="78" width="260" y="-39" x="-130" data-et="node" data-id="abc" style="" class="basic label-container"></rect><g transform="translate(-100, -24)" style="" class="label"><rect></rect><foreignobject height="48" width="200">`{=html}

::: {style="display: table; white-space: break-spaces; line-height: 1.5; max-width: 200px; text-align: center; width: 200px;" xmlns="http://www.w3.org/1999/xhtml"}
`<span class="nodeLabel">`{=html}
<p>
Description: select columns in a table
</p>
`</span>`{=html}
:::

`</foreignobject></g></g><g transform="translate(188, 314)" id="flowchart-reg_classes-6" class="node default"><rect height="78" width="260" y="-39" x="-130" data-et="node" data-id="abc" style="" class="basic label-container"></rect><g transform="translate(-100, -24)" style="" class="label"><rect></rect><foreignobject height="48" width="200">`{=html}

::: {style="display: table; white-space: break-spaces; line-height: 1.5; max-width: 200px; text-align: center; width: 200px;" xmlns="http://www.w3.org/1999/xhtml"}
`<span class="nodeLabel">`{=html}
<p>
Classes: select_block, tranform_block
</p>
`</span>`{=html}
:::

`</foreignobject></g></g><g transform="translate(188, 430)" id="flowchart-reg_input-7" class="node default"><rect height="54" width="188.3828125" y="-27" x="-94.19140625" data-et="node" data-id="abc" style="" class="basic label-container"></rect><g transform="translate(-64.19140625, -12)" style="" class="label"><rect></rect><foreignobject height="24" width="128.3828125">`{=html}

::: {style="display: table-cell; white-space: nowrap; line-height: 1.5; max-width: 200px; text-align: center;" xmlns="http://www.w3.org/1999/xhtml"}
`<span class="nodeLabel">`{=html}
<p>
Input: data.frame
</p>
`</span>`{=html}
:::

`</foreignobject></g></g><g transform="translate(188, 534)" id="flowchart-reg_output-8" class="node default"><rect height="54" width="201.0546875" y="-27" x="-100.52734375" data-et="node" data-id="abc" style="" class="basic label-container"></rect><g transform="translate(-70.52734375, -12)" style="" class="label"><rect></rect><foreignobject height="24" width="141.0546875">`{=html}

::: {style="display: table-cell; white-space: nowrap; line-height: 1.5; max-width: 200px; text-align: center;" xmlns="http://www.w3.org/1999/xhtml"}
`<span class="nodeLabel">`{=html}
<p>
Output: data.frame
</p>
`</span>`{=html}
:::

`</foreignobject></g></g><g transform="translate(188, 638)" id="flowchart-reg_package-9" class="node default"><rect height="54" width="172.859375" y="-27" x="-86.4296875" data-et="node" data-id="abc" style="" class="basic label-container"></rect><g transform="translate(-56.4296875, -12)" style="" class="label"><rect></rect><foreignobject height="24" width="112.859375">`{=html}

::: {style="display: table-cell; white-space: nowrap; line-height: 1.5; max-width: 200px; text-align: center;" xmlns="http://www.w3.org/1999/xhtml"}
`<span class="nodeLabel">`{=html}
<p>
Package: blockr
</p>
`</span>`{=html}
:::

`</foreignobject></g></g></g></g></g></g><g transform="translate(0, 388.5)" class="root"><g class="clusters"><g data-look="classic" id="blockr_custom" class="cluster"><rect height="129" width="414.171875" y="8" x="8" style=""></rect><g transform="translate(142.6328125, 8)" class="cluster-label"><foreignobject height="24" width="144.90625">`{=html}

::: {style="display: table-cell; white-space: nowrap; line-height: 1.5; max-width: 200px; text-align: center;" xmlns="http://www.w3.org/1999/xhtml"}
`<span class="nodeLabel">`{=html}
<p>
your_block_package
</p>
`</span>`{=html}
:::

`</foreignobject></g></g></g><g class="edgePaths"></g><g class="edgeLabels"></g><g class="nodes"><g transform="translate(116.54296875, 72.5)" id="flowchart-new_block1-0" class="node default"><rect height="54" width="147.0859375" y="-27" x="-73.54296875" data-et="node" data-id="abc" style="" class="basic label-container"></rect><g transform="translate(-43.54296875, -12)" style="" class="label"><rect></rect><foreignobject height="24" width="87.0859375">`{=html}

::: {style="display: table-cell; white-space: nowrap; line-height: 1.5; max-width: 200px; text-align: center;" xmlns="http://www.w3.org/1999/xhtml"}
`<span class="nodeLabel">`{=html}
<p>
New block 1
</p>
`</span>`{=html}
:::

`</foreignobject></g></g><g transform="translate(313.62890625, 72.5)" id="flowchart-new_block2-1" class="node default"><rect height="54" width="147.0859375" y="-27" x="-73.54296875" data-et="node" data-id="abc" style="" class="basic label-container"></rect><g transform="translate(-43.54296875, -12)" style="" class="label"><rect></rect><foreignobject height="24" width="87.0859375">`{=html}

::: {style="display: table-cell; white-space: nowrap; line-height: 1.5; max-width: 200px; text-align: center;" xmlns="http://www.w3.org/1999/xhtml"}
`<span class="nodeLabel">`{=html}
<p>
New block 2
</p>
`</span>`{=html}
:::

`</foreignobject></g></g></g></g></g></g></g>`{=html}
</svg>

</div>

`</figure>`{=html}

</div>
::::::::::::::::::::
:::::::::::::::::::::

To get an overview of all available blocks within the blockr core
package, we call `get_registry`:

:::: cell
``` {.r .cell-code}
get_registry()
```

::: {.cell-output .cell-output-stdout}
                     ctor                                  description  category
    1       arrange_block                              Arrange columns transform
    2           csv_block                           Read a csv dataset    parser
    3       dataset_block              Choose a dataset from a package      data
    4  filesbrowser_block       Select files on the server file system      data
    5        filter_block                       filter rows in a table transform
    6      group_by_block                             Group by columns transform
    7          head_block               Select n first rows of dataset transform
    8          join_block                              Join 2 datasets transform
    9          json_block                          Read a json dataset    parser
    10       mutate_block                                 Mutate block transform
    11          rds_block                           Read a rds dataset    parser
    12       result_block Shows result of another stack as data source      data
    13       select_block                    select columns in a table transform
    14    summarize_block                        summarize data groups transform
    15       upload_block                   Upload files from location      data
    16          xpt_block                           Read a xpt dataset    parser
                                                classes      input     output
    1             arrange_block, transform_block, block data.frame data.frame
    2   csv_block, parser_block, transform_block, block     string data.frame
    3                  dataset_block, data_block, block       <NA> data.frame
    4             filesbrowser_block, data_block, block       <NA>     string
    5              filter_block, transform_block, block data.frame data.frame
    6            group_by_block, transform_block, block data.frame data.frame
    7                head_block, transform_block, block data.frame data.frame
    8                join_block, transform_block, block data.frame data.frame
    9  json_block, parser_block, transform_block, block     string data.frame
    10             mutate_block, transform_block, block data.frame data.frame
    11  rds_block, parser_block, transform_block, block     string data.frame
    12                  result_block, data_block, block       <NA> data.frame
    13             select_block, transform_block, block data.frame data.frame
    14          summarize_block, transform_block, block data.frame data.frame
    15                  upload_block, data_block, block       <NA>     string
    16  xpt_block, parser_block, transform_block, block     string data.frame
       package
    1   blockr
    2   blockr
    3   blockr
    4   blockr
    5   blockr
    6   blockr
    7   blockr
    8   blockr
    9   blockr
    10  blockr
    11  blockr
    12  blockr
    13  blockr
    14  blockr
    15  blockr
    16  blockr
:::
::::

This function returns a dataframe containing information about blocks
such as their constructors, like `new_ode_block`, the description, the
category (data, transform, plot ... this is user defined), classes,
accepted input, returned output and package.

To register a block we call `register_block` (or `register_blocks` for
multiple blocks):

::: cell
``` {.r .cell-code}
register_my_blocks <- function() {
  register_block(
    constructor = new_ode_block,
    name = "ode block",
    description = "Computed the Lorent attractor solutions",
    classes = c("ode_block", "data_block"),
    input = NA_character_,
    output = "data.frame",
    package = "<YOUR_PACKAGE>",
    category = "data"
  )
  # You can register any other blocks here ...
}
```
:::

where `<YOUR_PACKAGE>` must be replaced by your real package name.

Within a `zzz.R` script, you can ensure to register any block when the
package loads with a **hook**:

``` r
.onLoad <- function(libname, pkgname) {
  register_my_blocks()
  invisible(NULL)
}
```

After the registration, you can check whether the registry is updated,
by looking at the ode block:

:::: cell
``` {.r .cell-code}
register_my_blocks()
reg <- get_registry()
reg[reg$package == "<YOUR_PACKAGE>", ]
```

::: {.cell-output .cell-output-stdout}
            ctor                             description category
    11 ode_block Computed the Lorent attractor solutions     data
                            classes input     output        package
    11 ode_block, data_block, block  <NA> data.frame <YOUR_PACKAGE>
:::
::::

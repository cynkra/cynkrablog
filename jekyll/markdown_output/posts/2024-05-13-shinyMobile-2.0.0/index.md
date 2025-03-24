---
author:
- Veerle van Leemput and David Granjon
authors:
- Veerle van Leemput and David Granjon
categories:
- Shiny
date: 2024-05-13
image: logo.png
layout: post
title: "shinyMobile 2.0.0: a preview"
toc-title: Table of contents
---

::: cell
``` {.r .cell-code}
library(shiny)
```
:::

![](logo.png){width="25%" fig-align="center"}

shinyMobile has been enabling the creation of exceptional R Shiny apps
for both iOS and Android for nearly five years, thanks to the impressive
open-source Framework7 [template](https://framework7.io/) that drives
its capabilities.

This year shinyMobile gets a major update to v2.2.0. I'd like to warmly
thank [Veerle van Leemput](https://hypebright.nl/) and Michael S. Czahor
from [AthlyticZ](https://linktr.ee/athlyticz) for providing significant
support during this marathon.

# What's new

shinyMobile 1.0.0 and above have been running on an old version of
Framework7 (v5). shinyMobile 2.0.0 has been upgraded to run the newer
Framework7 v8. With this comes a significant number of
[changes](https://github.com/RinteRface/shinyMobile/blob/69da6ca46984bf6c73e2dc32ff8d9f415ec36a30/NEWS.md),
but we believe these are all for the best!

## Major changes

### New multi pages experimental support

We are very excited to bring this feature out for this new release.
Under the hood, this is possible owing to the `{brochure}`
[package](https://github.com/ColinFay/brochure) from [Colin
Fay](https://github.com/ColinFay) as well as the internal Framework7
[router](https://framework7.io/docs/view) component.

#### What does this mean?

You can now develop **real multi pages** Shiny applications and have
different url endpoints and redirections. For instance,
`https://my-app/home` can be the home page while
`https://my-app/settings` brings to the settings page.

#### How does this work?

At the time of writting of this blog post, you must install a patched
`{brochure}` version with
`devtools::install_github("DivadNojnarg/brochure")`.

In the below code, we basically have 3 pages having their own content
and a common layout for consistency. The router ensure beautiful
transitions from one page to another. We invite you to look at the
getting started
[article](https://shinymobile.rinterface.com/articles/multipages) which
provides more technical details.

::: cell
``` {.r .cell-code}
library(shiny)
# Needs a specific version of brochure for now.
# This allows to pass wrapper functions with options
# as list. We need it because of the f7Page options parameter
# and to pass the routes list object for JS.
# devtools::install_github("DivadNojnarg/brochure")
library(brochure)
library(shinyMobile)

# Allows to use the app on a server like
# shinyapps.io where basepath is /app_name
# instead of "/" or "".
make_link <- function(path = NULL, basepath = "") {
  if (is.null(path)) {
    if (nchar(basepath) > 0) {
      return(basepath)
    } else {
      return("/")
    }
  }
  sprintf("%s/%s", basepath, path)
}

links <- lapply(2:3, function(i) {
  tags$li(
    f7Link(
      routable = TRUE,
      label = sprintf("Link to page %s", i),
      href = make_link(i)
    )
  )
})

page_1 <- function() {
  page(
    href = "/",
    ui = function(request) {
      shiny::tags$div(
        class = "page",
        # top navbar goes here
        f7Navbar(title = "Home page"),
        # NOTE: when the main toolbar is enabled in
        # f7MultiLayout, we can't use individual page toolbars.
        # f7Toolbar(
        #  position = "bottom",
        #  tags$a(
        #    href = "/2",
        #    "Second page",
        #    class = "link"
        #  )
        # ),
        # Page content
        tags$div(
          class = "page-content",
          f7List(
            inset = TRUE,
            strong = TRUE,
            outline = TRUE,
            dividers = TRUE,
            mode = "links",
            links
          ),
          f7Block(
            f7Text("text", "Text input", "default"),
            f7Select("select", "Select", colnames(mtcars)),
            textOutput("res"),
            textOutput("res2")
          )
        )
      )
    }
  )
}

page_2 <- function() {
  page(
    href = "/2",
    ui = function(request) {
      shiny::tags$div(
        class = "page",
        # top navbar goes here
        f7Navbar(
          title = "Second page",
          # Allows to go back to main
          leftPanel = tagList(
            tags$a(
              href = make_link(),
              class = "link back",
              tags$i(class = "icon icon-back"),
              tags$span(
                class = "if-not-md",
                "Back"
              )
            )
          )
        ),
        shiny::tags$div(
          class = "page-content",
          f7Block(f7Button(inputId = "update", label = "Update stepper")),
          f7List(
            strong = TRUE,
            inset = TRUE,
            outline = FALSE,
            f7Stepper(
              inputId = "stepper",
              label = "My stepper",
              min = 0,
              max = 10,
              size = "small",
              value = 4,
              wraps = TRUE,
              autorepeat = TRUE,
              rounded = FALSE,
              raised = FALSE,
              manual = FALSE
            )
          ),
          f7Block(textOutput("test"))
        )
      )
    }
  )
}

page_3 <- function() {
  page(
    href = "/3",
    ui = function(request) {
      shiny::tags$div(
        class = "page",
        # top navbar goes here
        f7Navbar(
          title = "Third page",
          # Allows to go back to main
          leftPanel = tagList(
            tags$a(
              href = make_link(),
              class = "link back",
              tags$i(class = "icon icon-back"),
              tags$span(
                class = "if-not-md",
                "Back"
              )
            )
          )
        ),
        shiny::tags$div(
          class = "page-content",
          f7Block("Nothing to show yet ...")
        )
      )
    }
  )
}

brochureApp(
  basepath = make_link(),
  # Pages
  page_1(),
  page_2(),
  page_3(),
  # Important: in theory brochure makes
  # each page having its own shiny session/ server function.
  # That's not what we want here so we'll have
  # a global server function.
  server = function(input, output, session) {
    output$res <- renderText(input$text)
    output$res2 <- renderText(input$select)
    output$test <- renderText(input$stepper)

    observeEvent(input$update, {
      updateF7Stepper(
        inputId = "stepper",
        value = 0.1,
        step = 0.01,
        size = "large",
        min = 0,
        max = 1,
        wraps = FALSE,
        autorepeat = FALSE,
        rounded = TRUE,
        raised = TRUE,
        color = "pink",
        manual = TRUE,
        decimalPoint = 2
      )
    })
  },
  wrapped = f7MultiLayout,
  wrapped_options = list(
    basepath = make_link(),
    # Common toolbar
    toolbar = f7Toolbar(
      f7Link(icon = f7Icon("house"), href = make_link(), routable = TRUE)
    ),
    options = list(
      dark = TRUE,
      theme = "md",
      routes = list(
        # Important: don't remove keepAlive
        # for pages as this allows
        # to save the input state when switching
        # between pages. If FALSE, each time a page is
        # changed, inputs are reset.
        list(
          path = make_link(),
          url = make_link(),
          name = "home",
          keepAlive = TRUE
        ),
        list(
          path = make_link("2"),
          url = make_link("2"),
          name = "2",
          keepAlive = TRUE
        ),
        list(
          path = make_link("3"),
          url = make_link("3"),
          name = "3",
          keepAlive = TRUE
        )
      )
    )
  )
)
```
:::

### Updated material design style

By updating to the latest Framework7 version, we now benefit from a
totally revamped Android (md) design, which looks more modern.

::: cell
``` {.r .cell-code}
library(shiny)
library(shinyMobile)
shinyAppDir(system.file("examples/gallery", package = "shinyMobile"))
```
:::

:::::::: columns
::: {.column width="20%"}
:::

::::: {.column width="60%"}
:::: cell
::: cell-output-display
<iframe class="border border-5 rounded shadow-lg" src="https://shinylive.io/r/app/#h=0&amp;code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAGwEsAjAJykYE8AKAZwAtaJWAlAB0IdJiw48+rALJF6tanGEQp-AILoAIrUZdWncjAwAzRXHZCwcAB6xUSzgHoA5lGpK2V3AAJUUAgBrKBc4HwBeHys1WXlzKwEBMABfAF0gA" style="zoom: 0.75;" width="100%" height="1100px"></iframe>
:::
::::
:::::

::: {.column width="20%"}
:::
::::::::

### Refined inputs layout and style

Whenever you have multiple inputs, we now recommend to wrap all of them
within `f7List()` so as to benefit from new styling options such as
outline, inset, strong. Internally, we use a function able to detect
whether the input is inside a `f7List()`. If this is the case, you can
style this list by passing parameters like
`f7List(outline = TRUE, inset = TRUE, ...)`. If not, the input is
internally wrapped in a list to have correct rendering, but no styling
is possible. Besides, some inputs like `f7Text()` can have custom
styling (add an icon, clear button, outline style), which is independent
from the external list wrapper style. Hence, we don't recommend doing
`f7List(outline = TRUE, f7Text(outline = TRUE))` since it won't render
well and instead use `f7List(outline = TRUE, f7Text())`.

Besides, independently from `f7List()`, some inputs having more specific
styling options:

-   `f7AutoComplete()`.
-   `f7Text()`, `f7Password()`, `f7TextArea()`.
-   `f7Select()`.
-   `f7Picker()`, `f7ColorPicker()` and `f7DatePicker()`.
-   `f7Radio()` and `f7CheckboxGroup()`.

In practices, you can design a supercharged `f7Text()` like so:

::: cell
``` {.r .cell-code}
f7Text(
  inputId = "text",
  label = "Text input",
  value = "Some text",
  placeholder = "Your text here",
  style = list(
    description = "A cool text input",
    outline = TRUE,
    media = f7Icon("house"),
    clearable = TRUE,
    floating = TRUE
  )
)
```
:::

This adds a description to the input (below its main content), as well
as the outline style option and an icon on the left side. `clearable` is
TRUE by default meaning that all text-based inputs can be cleared.
`floating` is an effect that makes the label move in and out the input
area depending on the content state. When empty, the label is inside and
when there is text, the label is pushed outside into its usual location.

`f7Stepper()` and `f7Toggle()` label is now displayed on the left.

::: cell
``` {.r .cell-code}
library(shiny)
library(shinyMobile)

shinyApp(
  ui = f7Page(
    options = list(dark = FALSE, theme = "ios"),
    title = "Inputs Layout",
    f7SingleLayout(
      navbar = f7Navbar(
        title = "Inputs Layout",
        hairline = FALSE
      ),
      f7List(
        inset = TRUE,
        dividers = TRUE,
        strong = TRUE,
        outline = FALSE,
        f7Text(
          inputId = "text",
          label = "Text input",
          value = "Some text",
          placeholder = "Your text here"
        ),
        f7TextArea(
          inputId = "textarea",
          label = "Text area input",
          value = "Some text",
          placeholder = "Your text here"
        ),
        f7Select(
          inputId = "select",
          label = "Make a choice",
          choices = 1:3,
          selected = 1
        ),
        f7AutoComplete(
          inputId = "myautocomplete",
          placeholder = "Some text here!",
          openIn = "dropdown",
          label = "Type a fruit name",
          choices = c(
            "Apple",
            "Apricot",
            "Avocado",
            "Banana",
            "Melon",
            "Orange",
            "Peach",
            "Pear",
            "Pineapple"
          )
        ),
        f7Stepper(
          inputId = "stepper",
          label = "My stepper",
          min = 0,
          color = "default",
          max = 10,
          value = 4
        ),
        f7Toggle(
          inputId = "toggle",
          label = "Toggle me"
        ),
        f7Picker(
          inputId = "picker",
          placeholder = "Some text here!",
          label = "Picker Input",
          choices = c("a", "b", "c"),
          options = list(sheetPush = TRUE)
        ),
        f7DatePicker(
          inputId = "date",
          label = "Pick a date",
          value = Sys.Date()
        ),
        f7ColorPicker(
          inputId = "mycolorpicker",
          placeholder = "Some text here!",
          label = "Select a color"
        )
      ),
      f7CheckboxGroup(
        inputId = "checkbox",
        label = "Checkbox group",
        choices = c("a", "b", "c"),
        selected = "a",
        style = list(
          inset = TRUE,
          dividers = TRUE,
          strong = TRUE,
          outline = FALSE
        )
      ),
      f7Radio(
        inputId = "radio",
        label = "Radio group",
        choices = c("a", "b", "c"),
        selected = "a",
        style = list(
          inset = TRUE,
          dividers = TRUE,
          strong = TRUE,
          outline = FALSE
        )
      )
    )
  ),
  server = function(input, output) {
  }
)
```
:::

:::::::: columns
::: {.column width="25%"}
:::

::::: {.column width="50%"}
:::: cell
::: cell-output-display
<iframe class="border border-5 rounded shadow-lg" src="https://shinylive.io/r/app/#h=0&amp;code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAGwEsAjAJykYE8AKAZwAtaJWAlAB0IdJiw48+rALJF6tanGEQRU-gEF07EQAJdAV1q6AvLoBmAdgAKUAOZwdEffqKpStEp1O66nUuwAJiwA1j4AYhoAMgDKAKK4uqTccPA+QmCenBkCuHouHqRK6WAAkhCoBqTeUVCsRFUZec4uVjF8dkq19VVOLi7QAG70LD5WAHJQwyx9-QW0RXAl5ZXVut0NpE35c7rcULSMdBBLZpGxcTsuuVf6VlG0-rO7fJxwpD4AKlgAqgm3LkCtEGtECcEY3jM3z+zV2+n8jBIdi+v3+LV2m2Op1053isLhVk+cAAHgEAf0+KtSoESuRSdt0XDqFB6HBqCUiaTdJTGnhyS5BlBqAZsRkYkQ0nStnzGbtUMyCHBuERqGDGCUAJoNdVSvbguAZfk3WWtSyc0gaRhwKDPOE80jU2kk0gsa0MuEuZms9lmDLm3SuqDciq8-EewXC0VgcWS53uj26eVQRXK1XgzXapLOvVWw0m-TGj1tNlwAhk-Mue2O31gN5KMvxj1etklGRQEJLIMEZW0RWNuHdoi9uCQ3QARkQAGYw3C66XyDSzGOjTP+lYNFUiABhCXy96Ofn6KuL3QZGCsKCb4gwPfkftyhVKlVqkoxpa6lJWgCE97mbgo5QlIEiKoIERAAO6qDKCa+CyLY1p8rCoJ2FiMEYHzQPAv79IOw6jgQtoehkWh7thczEagjC9kQ0qrnCxGDEQBBQGBZH9BkABCUDQNAbEuBkMhsiQfH6BkADyzAQA4ImnmA1jWt2MkZPJLBKXJfDWugSh5jBKgeoWBKWDE5DoOChFzMeJT+HApmMHxzY+rJMisLo1m2XxMB8D4AAMdE4SqRDqjWYLmJe1C0YeugwFAxI+GOvmRRGIo+AALCu-KEkQdidAeFZHiGDonhkpBZTl9lwY5fqlcUWFgOlFZWNYvYdow5kUgV1ayagzXgnxSYps+6Y1m+WZcp+cA-tBCYOSUTUEC1ugrKGkW4Yq+E6CgTSyfQW0ZAQOR+S4bgeF4Ph+AEPBwO81gGDwKJ-HpcIGbsVgACJQOQc0tW1lYdUVYDBHeU1NhVs3NQGuiAwawNwkl2IxKwnAYO95DsI9uzPXMVg7tQgVfWZkWWTW57ELjjDdfNvUww+yZPmmQWySNH76pNh36DNw0lmWEOk4FOlPQCmN3JYW4pPN9BEMSADiiIGKgP1E7J3aliEEvEmRHOyaLKtq7odiy6gZGrSOPgERkUC7WAO14ErB38nOZZwP9FvUy4-isMUZjnT9+VvB8UKomzkPAqC4KjtCaIwQiSL3ZHCaYhpETRPERqC3RVhYCxngK39JTMECRAa6DNaZwXesG0bPZrabG0u4kGTW-XhB2xWDsLiUdf26QHvYt7hMQH7sdB0CIJquHgeRdHUlD5FCcnEnFypya6O6I9BlvIwgxDRYBgQGWngQOw9qJJsqwCLoID5AAviIAhgFfAC6QA" style="zoom: 0.75;" width="100%" height="1100px"></iframe>
:::
::::
:::::

::: {.column width="25%"}
:::
::::::::

::: cell
``` {.r .cell-code}
library(shiny)
library(shinyMobile)

shinyApp(
  ui = f7Page(
    options = list(dark = FALSE, theme = "ios"),
    title = "Inputs Layout",
    f7SingleLayout(
      navbar = f7Navbar(
        title = "Inputs Layout",
        hairline = FALSE
      ),
      f7List(
        inset = TRUE,
        dividers = TRUE,
        strong = TRUE,
        outline = FALSE,
        f7Text(
          inputId = "text",
          label = "Text input",
          value = "Some text",
          placeholder = "Your text here"
        ),
        f7TextArea(
          inputId = "textarea",
          label = "Text area input",
          value = "Some text",
          placeholder = "Your text here"
        ),
        f7Select(
          inputId = "select",
          label = "Make a choice",
          choices = 1:3,
          selected = 1
        ),
        f7AutoComplete(
          inputId = "myautocomplete",
          placeholder = "Some text here!",
          openIn = "dropdown",
          label = "Type a fruit name",
          choices = c(
            "Apple",
            "Apricot",
            "Avocado",
            "Banana",
            "Melon",
            "Orange",
            "Peach",
            "Pear",
            "Pineapple"
          )
        ),
        f7Stepper(
          inputId = "stepper",
          label = "My stepper",
          min = 0,
          color = "default",
          max = 10,
          value = 4
        ),
        f7Toggle(
          inputId = "toggle",
          label = "Toggle me"
        ),
        f7Picker(
          inputId = "picker",
          placeholder = "Some text here!",
          label = "Picker Input",
          choices = c("a", "b", "c"),
          options = list(sheetPush = TRUE)
        ),
        f7DatePicker(
          inputId = "date",
          label = "Pick a date",
          value = Sys.Date()
        ),
        f7ColorPicker(
          inputId = "mycolorpicker",
          placeholder = "Some text here!",
          label = "Select a color"
        )
      ),
      f7CheckboxGroup(
        inputId = "checkbox",
        label = "Checkbox group",
        choices = c("a", "b", "c"),
        selected = "a",
        style = list(
          inset = TRUE,
          dividers = TRUE,
          strong = TRUE,
          outline = FALSE
        )
      ),
      f7Radio(
        inputId = "radio",
        label = "Radio group",
        choices = c("a", "b", "c"),
        selected = "a",
        style = list(
          inset = TRUE,
          dividers = TRUE,
          strong = TRUE,
          outline = FALSE
        )
      )
    )
  ),
  server = function(input, output) {
  }
)
```
:::

Moreover, we added a new way to pass options to `f7Radio()` and
`f7CheckboxGroup()`, namely `f7CheckboxChoice()` and `f7RadioChoice()`
(note: you can't use `update_*` functions on them yet), so that you can
pass more metadata and a description to each option (instead of just the
choice name in basic shiny inputs):

::: cell
``` {.r .cell-code}
library(shiny)
library(shinyMobile)

shinyApp(
  ui = f7Page(
    title = "Update radio",
    f7SingleLayout(
      navbar = f7Navbar(title = "Update f7Radio"),
      f7Block(
        f7Radio(
          inputId = "radio",
          label = "Custom choices",
          choices = list(
            f7RadioChoice(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit.
            Nulla sagittis tellus ut turpis condimentum,
            ut dignissim lacus tincidunt",
              title = "Choice 1",
              subtitle = "David",
              after = "March 16, 2024"
            ),
            f7RadioChoice(
              "Cras dolor metus, ultrices condimentum sodales sit
            amet, pharetra sodales eros. Phasellus vel felis tellus.
            Mauris rutrum ligula nec dapibus feugiat",
              title = "Choice 2",
              subtitle = "Veerle",
              after = "March 17, 2024"
            )
          ),
          selected = 2,
          style = list(
            outline = TRUE,
            strong = TRUE,
            inset = TRUE,
            dividers = TRUE
          )
        ),
        textOutput("res")
      )
    )
  ),
  server = function(input, output, session) {
    output$res <- renderText(input$radio)
  }
)
```
:::

:::::::: columns
::: {.column width="20%"}
:::

::::: {.column width="60%"}
:::: cell
::: cell-output-display
<iframe class="border border-5 rounded shadow-lg" src="https://shinylive.io/r/app/#h=0&amp;code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAGwEsAjAJykYE8AKAZwAtaJWAlAB0IdJiw48+rALJF6tanGEQRU-gEF07EQAJdAV1q6AvLoBmAdgAKUAOZwdEfftK1SS07qFgAqqgATKHJdZgDaIh9cPRcrAGU+OyUAGShWIgNSJxcXaAA3ehYvKwA5KAKWdjcPOC8ffyCQqywocMiwAWjnHItLACFqIgIAa2ye-WbWiLHx-T5UTIBJALqwMIiomNndaih6OGpVgGEDTlIiGF0CbiJaAjhOTe7t69v7zi86M5nt3pa2o43O6OLa-fQ+ZJERhwS60VCcAyXAJEQaMXScdy6WBwUi4K4kThwAjkUgGNFTVC0TgERK6A7uDCg7YlAzUXbo+zuNwfchs06GUi6UmMSkfYgQcLwMiIrpg-SZXThOwQKkYy67Aj8twQGkBAxkJ5ylzVTxmHyAt61ACMhqN6IM9BNtTNYAAIuVaAFbUaoOZyGiXTIWNddFaAGx4gBMAAZIwAWHxM2adJPjSYAoH3H5g83MD7I1G6eCkzh41mkRjAsUkSUUUmXThEIJKD4Y0ipnrY3G6VDcFg45joptQFt0xhETgYXTWPuEvkfPIHCz0nkHainRnPX5BslU0KZRiIna0OysqC6CBExVoBj88xwAx2WjBb1yp3HTO1SOvsEIx3uU1vDAAA1OA4EYJQf1+X1-VWINGBDK1LCjWMEzADschUMEUy3cY5yJcgVjMSNZV+M5WEAr4sgwlwMg8PhnV0AAVLBfAAUVI38KxIOwvBY9jON+PhCUFMx+I4mj9HCPJPXAj4xNYtiaKw5NBJycgAA9SAAeUyBZqLWB4fBUzDQRUnD9EJRhFwDCx9WJCIIHYeZMjxOj9LxQlOAxEgBF0EBQXczIABJoQ+AAeABaUIKACcCmLgLTnIgfTQqmIgVIAXxEAQwEygBdIA" style="zoom: 0.75;" width="100%" height="1100px"></iframe>
:::
::::
:::::

::: {.column width="20%"}
:::
::::::::

::: cell
``` {.r .cell-code}
library(shiny)
library(shinyMobile)

shinyApp(
  ui = f7Page(
    title = "Update radio",
    f7SingleLayout(
      navbar = f7Navbar(title = "Update f7Radio"),
      f7Block(
        f7Radio(
          inputId = "radio",
          label = "Custom choices",
          choices = list(
            f7RadioChoice(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit.
            Nulla sagittis tellus ut turpis condimentum,
            ut dignissim lacus tincidunt",
              title = "Choice 1",
              subtitle = "David",
              after = "March 16, 2024"
            ),
            f7RadioChoice(
              "Cras dolor metus, ultrices condimentum sodales sit
            amet, pharetra sodales eros. Phasellus vel felis tellus.
            Mauris rutrum ligula nec dapibus feugiat",
              title = "Choice 2",
              subtitle = "Veerle",
              after = "March 17, 2024"
            )
          ),
          selected = 2,
          style = list(
            outline = TRUE,
            strong = TRUE,
            inset = TRUE,
            dividers = TRUE
          )
        ),
        textOutput("res")
      )
    )
  ),
  server = function(input, output, session) {
    output$res <- renderText(input$radio)
  }
)
```
:::

### New `f7Treeview()` component

The new release welcomes a brand new input widget. As its name suggests,
`f7Treewiew()` enables sorting items hierarchically within a collapsible
nested list of items. This is ideal, for instance, to select files
within multiple folders, as an alternative to the classic `fileInput()`.

::: cell
``` {.r .cell-code}
library(shiny)
library(shinyMobile)

shinyApp(
  ui = f7Page(
    title = "My app",
    f7SingleLayout(
      navbar = f7Navbar(title = "f7Treeview"),
      # group treeview with selectable items
      f7BlockTitle("Selectable items"),
      f7Block(
        f7Treeview(
          id = "treeview1",
          selectable = TRUE,
          f7TreeviewGroup(
            title = "Selected images",
            icon = f7Icon("folder_fill"),
            itemToggle = TRUE,
            lapply(
              1:3,
              function(i) {
                f7TreeviewItem(
                  label = paste0("image", i, ".png"),
                  icon = f7Icon("photo_fill")
                )
              }
            )
          )
        ),
        textOutput("selected")
      ),

      # group treeview with checkbox items
      f7BlockTitle("Checkbox"),
      f7Block(
        f7Treeview(
          id = "treeview2",
          withCheckbox = TRUE,
          f7TreeviewGroup(
            title = "Selected images",
            icon = f7Icon("folder_fill"),
            itemToggle = TRUE,
            lapply(
              1:3,
              function(i) {
                f7TreeviewItem(
                  label = paste0("image", i, ".png"),
                  icon = f7Icon("photo_fill")
                )
              }
            )
          )
        ),
        textOutput("selected2")
      )
    )
  ),
  server = function(input, output) {
    output$selected <- renderText(input$treeview1)
    output$selected2 <- renderText(input$treeview2)
  }
)
```
:::

:::::::: columns
::: {.column width="20%"}
:::

::::: {.column width="60%"}
:::: cell
::: cell-output-display
<iframe class="border border-5 rounded shadow-lg" src="https://shinylive.io/r/app/#h=0&amp;code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAGwEsAjAJykYE8AKAZwAtaJWAlAB0IdJiw48+rALJF6tanGEQRU-gEF07EQAJdAV1q6AvLoBmAdgAKUAOZwdEfftK1SS07qFgZrXWioPrh6LlYAynx2SgAyUKxEBqROLi7QAG70LF5WAHJQmSzsbh5wXj5WACqMcHDptHAA7j4CIc6pugDEunaMiai6pDV1DY26je7cupxwSgSkUPSe7nAwnKGpVgBC1EQEANaV7ko6YOGzcPOLy+RrLW0dFpY7e-spj0-VtfVN7x+6tAAJuUwENvqMAIzBDYfGZzBZLMpmSpYACqAFEHv9PsMfo0AOJ9AyoP7YkqeMw+c7wuDA2gwexwdZ4GH-WjEZxmKwASQ5p3MRGogLgjAA+uZFNR7qyPisYJUiHZokjdCiMVjsbpqIFqBwZf8IYgAMwazUWAwQea0EjsWgCXQgfXYqq40bc26ks0ubX0WZeVBQTjkAAMp3pjOCANw3jAGFQEDs0vaXtS7JIOUsvJtPlQ3CIpCI4slLSd-xUKd0AF9Sy5y9i649Wk7yAAPUgAeSSqCSpzhl3IgJLydrbRl3V6-UGrqa40mugI3Eu+3oRBbANu62H+m2uwOR1KpwAwouDiuW0nHjvXp6wpYviNfjWgSCwQ-GgAmaFbjoTUjcY9LmeXhqpiNYuuCTSEv0N6POSKpUhc8y0gCDIOMyppshyGZZhA-KCsKYoStQUpgE236PHKCpKhSqpoqB5EdNq6C6jBHyGiaNabBaVo2naDqcR04Fvu6qysZqPp+mYAZBnAoY+OGDiRrQ0Y+HGCYXhWLhppyTw4acub5oWREkQ2KamZq1YMak5kdDZ+hkf8rYdl2PY+H2SGAp+pEyqZdYOdMIrpCKOTcW4vEQN2pDRokpCRfajrDjFkUACTuQOugADwALS6DUEAEZUcBtraEVJMlr54hCplJWVaW0u+mU5XlBVFckfApRVozvnWlkCGAlYALpAA" style="zoom: 0.75;" width="100%" height="1100px"></iframe>
:::
::::
:::::

::: {.column width="20%"}
:::
::::::::

::: cell
``` {.r .cell-code}
library(shiny)
library(shinyMobile)

shinyApp(
  ui = f7Page(
    title = "My app",
    f7SingleLayout(
      navbar = f7Navbar(title = "f7Treeview"),
      # group treeview with selectable items
      f7BlockTitle("Selectable items"),
      f7Block(
        f7Treeview(
          id = "treeview1",
          selectable = TRUE,
          f7TreeviewGroup(
            title = "Selected images",
            icon = f7Icon("folder_fill"),
            itemToggle = TRUE,
            lapply(
              1:3,
              function(i) {
                f7TreeviewItem(
                  label = paste0("image", i, ".png"),
                  icon = f7Icon("photo_fill")
                )
              }
            )
          )
        ),
        textOutput("selected")
      ),

      # group treeview with checkbox items
      f7BlockTitle("Checkbox"),
      f7Block(
        f7Treeview(
          id = "treeview2",
          withCheckbox = TRUE,
          f7TreeviewGroup(
            title = "Selected images",
            icon = f7Icon("folder_fill"),
            itemToggle = TRUE,
            lapply(
              1:3,
              function(i) {
                f7TreeviewItem(
                  label = paste0("image", i, ".png"),
                  icon = f7Icon("photo_fill")
                )
              }
            )
          )
        ),
        textOutput("selected2")
      )
    )
  ),
  server = function(input, output) {
    output$selected <- renderText(input$treeview1)
    output$selected2 <- renderText(input$treeview2)
  }
)
```
:::

### New `f7Form()`

Shiny does not provide HTML forms handling out of the box (a
[form](https://www.w3schools.com/html/html_forms.asp) being composed of
multiple input elements). That's why we introduce `f7Form()`. Contrary
to basic shiny inputs, we don't get one input value per element but a
single input value with a nested list for all inputs within the form,
thereby allowing a reduction in the number of inputs on the server side.
`updateF7Form()` can quickly update any input from the form. As a side
note, the current list of supported inputs is:

-   `f7Text()`
-   `f7TextArea()`
-   `f7Password()`
-   `f7Select()`

::: cell
``` {.r .cell-code}
library(shiny)
library(shinyMobile)

shinyApp(
  ui = f7Page(
    f7SingleLayout(
      navbar = f7Navbar(title = "Inputs form"),
      f7Block(f7Button("update", "Click me")),
      f7BlockTitle("A list of inputs in a form"),
      f7List(
        inset = TRUE,
        dividers = FALSE,
        strong = TRUE,
        f7Form(
          id = "myform",
          f7Text(
            inputId = "text",
            label = "Text input",
            value = "Some text",
            placeholder = "Your text here",
            style = list(
              description = "A cool text input",
              outline = TRUE,
              media = f7Icon("house"),
              clearable = TRUE,
              floating = TRUE
            )
          ),
          f7TextArea(
            inputId = "textarea",
            label = "Text Area",
            value = "Lorem ipsum dolor sit amet, consectetur
              adipiscing elit, sed do eiusmod tempor incididunt ut
              labore et dolore magna aliqua",
            placeholder = "Your text here",
            resize = TRUE,
            style = list(
              description = "A cool text input",
              outline = TRUE,
              media = f7Icon("house"),
              clearable = TRUE,
              floating = TRUE
            )
          ),
          f7Password(
            inputId = "password",
            label = "Password:",
            placeholder = "Your password here",
            style = list(
              description = "A cool text input",
              outline = TRUE,
              media = f7Icon("house"),
              clearable = TRUE,
              floating = TRUE
            )
          )
        )
      ),
      verbatimTextOutput("form")
    )
  ),
  server = function(input, output, session) {
    output$form <- renderPrint(input$myform)

    observeEvent(input$update, {
      updateF7Form(
        "myform",
        data = list(
          "text" = "New text",
          "textarea" = "New text area",
          "password" = "New password"
        )
      )
    })
  }
)
```
:::

:::::::: columns
::: {.column width="20%"}
:::

::::: {.column width="60%"}
:::: cell
::: cell-output-display
<iframe class="border border-5 rounded shadow-lg" src="https://shinylive.io/r/app/#h=0&amp;code=NobwRAdghgtgpmAXGKAHVA6ASmANGAYwHsIAXOMpMAGwEsAjAJykYE8AKAZwAtaJWAlAB0IdJiw48+rALJF6tanGEQRU-gEF07EQAJdAV1q6AvLoBmAdgAKUAOZwdEffqsBlPnaUAZKKyIGpE4uLtAAbvQsphaWAHJQESzspLSkStFCYACSEKiBnBZEjDCZArh6ITEAQtREBADW7FZVgaQkOmAGqAAmUOSZuLqZAMJ0DbrwpWUVIc21DQAqqUodGrp0nKS6ROa6fHmkBXy6UIXFpeXOlVbetJvBlfp8nHBbZgtYAKoAopeP+t1aGFaN04IwCmYAGIabxuX4zSqbRgkOzRD4-P7-KyQoowB7-PbdDJgGCscy4gYIx5WBZwAAeQSp-32gSyRLMmXIDMpVwJ+moUHocGoxNpDL2uUCPL5LjCUGoBjgxLcRHgui5pGlMt0qAFBDg3CI1FBjGJAE0AqaNbpuGC4FqZZtWOkzBtGbztaDOARGLRUCkSMS1sQjer6VsWZq8EyCQE0nwle8vvCPTL4IDTmYrFliBAOoaDC8LjH-gQlCxBS7dOiU9qXOZan1PGjkyWQioZdNU9dLGLSBpGHAoPi+ZG2cSNSwhw6+QKhSKOWA+7oB9Po93HnKFYmhmBvEU4DA9qhOAYj90jUVdJxUid4KRBrmXgRyKQDIw25UoIDUHcCM3hVSQYXiJC9dDgWhCxgIgiXIGBUCvPh-0BboDDIQxNQ3f45wPcCtgvWpBwmexoBOOgAEcDCgGcCV1KB9UNY0wXNS0w3FW1Bxo-5BxvAAvHca0xR1SGdHc3RHGUvR9P0A2cRdgyIUNrUjLjY0COgIAE5MhO1dNaEzGIc3aTICyLMAuzrfQyyHZh6CrQTP1mRsUggVEkx+RzdA7PkLL5KxbE4TgAHcim6CTmUlUhx0XVAoECkLGG6VTKjnYViQC4LQsQZKQjohijRNFj3x1OLMsSm07RylwnSrcTPIBOBvV9f1aEDeTdBDEVlMiqqQjjDStIxeqJjgDNomzXN8wCMzfLrayKzswba0shsiCbVyWw8rD20-bzHj2lxZtlMFIhSGA+wAeUCA4OnJc5zIRbzfJeRgwmYrM0JfVq80jQY4wOYDGpvEgBF0EAEX+wIABI7qPAAeABaXRBwgE1rF9Mh2EjKHSVhlQIfoF63u+N7MexrpenIQZwe7Cm+jgSFLBxYpwv0TJcYpdcCUpgy6u23cNUyYlYjgIK2KjHTHk5cMp2osBhdF8WTkHOXJcqTJYvi0KhcXEWxc1sqkrAEsDv0A6AF9vPNkQBDAc2AF0gA" style="zoom: 0.75;" width="100%" height="1100px"></iframe>
:::
::::
:::::

::: {.column width="20%"}
:::
::::::::

::: cell
``` {.r .cell-code}
library(shiny)
library(shinyMobile)

shinyApp(
  ui = f7Page(
    f7SingleLayout(
      navbar = f7Navbar(title = "Inputs form"),
      f7Block(f7Button("update", "Click me")),
      f7BlockTitle("A list of inputs in a form"),
      f7List(
        inset = TRUE,
        dividers = FALSE,
        strong = TRUE,
        f7Form(
          id = "myform",
          f7Text(
            inputId = "text",
            label = "Text input",
            value = "Some text",
            placeholder = "Your text here",
            style = list(
              description = "A cool text input",
              outline = TRUE,
              media = f7Icon("house"),
              clearable = TRUE,
              floating = TRUE
            )
          ),
          f7TextArea(
            inputId = "textarea",
            label = "Text Area",
            value = "Lorem ipsum dolor sit amet, consectetur
              adipiscing elit, sed do eiusmod tempor incididunt ut
              labore et dolore magna aliqua",
            placeholder = "Your text here",
            resize = TRUE,
            style = list(
              description = "A cool text input",
              outline = TRUE,
              media = f7Icon("house"),
              clearable = TRUE,
              floating = TRUE
            )
          ),
          f7Password(
            inputId = "password",
            label = "Password:",
            placeholder = "Your password here",
            style = list(
              description = "A cool text input",
              outline = TRUE,
              media = f7Icon("house"),
              clearable = TRUE,
              floating = TRUE
            )
          )
        )
      ),
      verbatimTextOutput("form")
    )
  ),
  server = function(input, output, session) {
    output$form <- renderPrint(input$myform)

    observeEvent(input$update, {
      updateF7Form(
        "myform",
        data = list(
          "text" = "New text",
          "textarea" = "New text area",
          "password" = "New password"
        )
      )
    })
  }
)
```
:::

## Breaking changes

Some components have disappeared from Framework7 and we had to deprecate
them as they no longer work. Other long time deprecated `{shinyMobile}`
elements are also removed to cleanup the codebase. We invite you to
review the
[changelog](https://github.com/RinteRface/shinyMobile/blob/69da6ca46984bf6c73e2dc32ff8d9f415ec36a30/NEWS.md#breaking-changes)
to see a list of all changes in this release.

## Soft deprecation

Some function parameters have changed and are now deprecated with
`{lifecycle}`. You'll see a warning message if you use them and we
invite you to accordingly update your code.

# Conclusion

Since the release of `{shiny}` in 2012, many packages have been released
that substantially improve its layout and design such as `{bslib}`,
`{bs4Dash}` or `{shiny.fluent}`. Yet not much was done for mobile
development. `{shinyMobile}` tries to fill this gap by exposing people
to the rich Framework7 mobile-first template. Coupled with progressive
web app support (PWA), you can run Shiny apps on a mobile that look very
close to native apps with a desktop icon, a launch screen and running
fullscreen, that is without the web browser navigation bar. By including
an experimental implementation of the multipage navigation as described
earlier, we move one step closer to the native apps. Finally, owing to
the progress on the [webR](https://docs.r-wasm.org/webr/latest/) side,
it isn't impossible that one day, we might run a totally offline Shiny
app on mobile.

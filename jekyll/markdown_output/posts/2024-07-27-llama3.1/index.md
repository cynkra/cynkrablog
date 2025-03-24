---
author:
- Christoph Sax
authors:
- Christoph Sax
categories:
- LLM
date: 2024-07-27
image: llama.png
title: Playing with Llama 3.1 in R
toc-title: Table of contents
---

Meta [recently announced Llama
3.1](https://ai.meta.com/blog/meta-llama-3-1/), and there's a lot of
excitement. I finally had some time to experiment with locally run
open-source models. The small 8B model, in particular, produces
surprisingly useful output, with reasonable speed. Getting started is
straightforward.

## Running Llama 3.1 Locally

First, you'll need to install Ollama, which you can download from
[here](https://ollama.com/download).

Next, open your terminal and run:

``` sh
ollama run llama3.1:8b
```

This command will pull and run the smallest Llama 3.1 model, which
operates at a reasonable speed even on a MacBook Air. To exit, type
`/bye`.

You can also directly provide a prompt in the terminal:

``` sh
ollama run llama3.1:8b "Tomorrow is a..."
```

## Using Llama 3.1 from R

Hause Lin has created a lovely R wrapper for Ollama, allowing you to use
Llama 3.1 within your R scripts. To install the wrapper, use:

``` r
devtools::install_github("hauselin/ollamar")
```

Now, you can use it as follows:

``` r
library(ollamar)

generate("llama3.1", "Tomorrow is a...", output = "text")
```

## Applications

Running this locally without privacy concerns opens up a so many
possibilities. For example, if you want to get a short summary of all
the README files in your Git folder, you can do something like this:

``` r
library(fs)
library(tidyverse)
library(ollamar)

files <-
  fs::dir_ls("~/git", recurse = TRUE, glob = "*.md") |>
  head(4)

summarize_md <- function(file) {
  generate(
    "llama3.1",
    paste(
      "Summarize in 3 bullet points, ",
      "use a descriptive title, ",
      "avoid sentences like 'this is a summary...', or 'Here are the 3 bullet points...'.",
      paste(readLines(file), collapse = "\n")
    ),
    output = "text"
  )
}

ans <-
  tibble(file = files) |>
  mutate(summary = map_chr(file, summarize_md))

ans
#> # A tibble: 5 × 2
#>   file                                                   summary
#>   <fs::path>                                             <chr>
#> 1 /Users/christophsax/git/adminr/201909_slides/README.md "**Autumn Meetup Highl…
#> 2 /Users/christophsax/git/adminr/202103_slides/README.md "**Key Takeaways from …
#> 3 /Users/christophsax/git/adminr/202205_slides/README.md "**Spring Meetup 2022 …
#> 4 /Users/christophsax/git/adminr/202212_slides/README.md "**Key Takeaways from …
```

With this setup, you can quickly generate summaries for README files, or
any other text documents, directly within R. Happy experimenting!

---
author:
- David Schoch
authors:
- David Schoch
categories:
- R
- Testing
date: 2025-03-04
excerpt: A small team at cynkra is working on the R package igraph, a
  popular package for simple graphs and network analysis. A big part of
  this work involves refactoring legacy code and enhancing the
  maintainability of the package for the future.
image: pexels-pixabay-163064.jpg
layout: post
title: Organizing tests in R packages
toc-title: Table of contents
---

A small team at cynkra is working on the R package
[igraph](https://r.igraph.org/), a popular package for simple graphs and
network analysis. A big part of this work involves refactoring legacy
code and enhancing the maintainability of the package for the future.
One such task was to reorganize and refactor the tests of the package.

## Organizing R files

Before talking about the organization of test files, let us briefly talk
about how to organize R scripts that contain the functions within an R
package under `R/`. Should each function be in its own file? So should

``` r
my_mult <- function(a,b){
  a * b
}

my_sum <- function(a,b){
  a + b
}

my_hello <- function(name){
  glue::glue("Hello {name}!")
}

my_bye <- function(name){
  glue::glue("Goodbye {name}!")
}
```

live in `R/my_mult.R`, `R/my_sum`, `R/my_hello.R`, and `R/my_bye.R`? Or
should the all live together in one file `R/my-functions.R`? You might
guess that neither approach is optimal, especially when a package
contains many functions. Either you have dozens (or hundreds!)of files
under`R/`our you have one large script with thousands of lines of codes.
While there is no real best practice, both of these extremes should
generally be avoided. The best approach usually is to try to organize
your functions in*modules* of related functions.

In `igraph`, files are organized according to graph theoretic tasks. So
for example`R/centrality.R` contains all functions that compute
importance of nodes in networks or `R/community.R` contains all
functions to cluster a network.

In similar spirit we would organize our functions above in two files.
`my_mult()` and `my_sum()` would go into something like
`R/my_operators.R` and `my_hello()` and `my_bye()` into
`R/my_greetings.R`.

For more details on organizing your files in an R package see the book
[R Packages (2e)](https://r-pkgs.org/code.html#sec-code-organising).
There is also a lot of useful tips for how to navigate your files and
how to find specific functions more efficiently than scrolling around.

## Organizing test files

Equally important, but probably less often considered, is the way test
files should be organized (the files `test/testthat/test-*.R`). The
simplest and best way is to follow the guidance from the section above
and modularize the tests. In the case of tests, you actually do not have
to do anything new, simply use the same modularization as for the R
script files. So if there is a file `R/my_operators.R`, there should be
a `tests/testthat/test-my_operators.R`.

In your own packages, you can easily achieve this type from the start by
using

``` r
usethis::use_test()
```

As the help states:

> \[...\] makes it easy to create paired R and test files, using the
> convention that **the tests for R/foofy.R should live in
> tests/testthat/test-foofy.R**.

So you do not need to worry about naming your test files correctly if
you call this function while you have the R file `R/foofy.R` open
because it is automatically created for you. Besides convenience, this
also has very practical benefits, which are described in the book [R
packages (2e)](https://r-pkgs.org/testing-basics.html#create-a-test).
For example, it is easier to jump from one file to the other using
`use_test()` and `use_r()`.

## Cleanup of igraph test files

One goal of our refactoring efforts in `igraph`was to achieve a
one-to-one correspondence between R files (there exist around 90 R
script files) and test files. The way igraph grew over the years, there
were many things to fix in the organization of the test files. Some
files only tested singular functions, and some contained a mix of
functions from different R scripts. The function below is used to check
how off the mapping is by trying to match test files to R script files.
You simply need to provide a CRAN (GitHub) archive link and the function
computes the number of test files that do not have a corresponding R
script.

``` r
check_test_mapping <- function(url) {
  temp_file <- tempfile(fileext = ".tar.gz")
  temp_dir <- tempfile()
  dir.create(temp_dir)
  download.file(url, temp_file, mode = "wb")

  untar(temp_file, exdir = temp_dir)
  pkg_dir <- list.dirs(temp_dir, recursive = FALSE)[1]

  r_files <- list.files(
    file.path(pkg_dir, "R"),
    recursive = TRUE,
    full.names = FALSE
  )

  test_files <- list.files(
    file.path(pkg_dir, "tests/testthat"),
    pattern = "test-",
    recursive = FALSE,
    full.names = FALSE
  )

  unlink(temp_file)
  unlink(temp_dir)
  tested_r_files <- test_files |> stringr::str_remove("^test-")
  length(test_files[!tested_r_files %in% r_files])
}
```

Version 1.6.0 of igraph roughly corresponds to when cynkra started to
work on igraph.

``` r
url <- "https://cran.r-project.org/src/contrib/Archive/igraph/igraph_1.6.0.tar.gz"
check_test_mapping(url)
```

    [1] 144

This version contains 144 test files which do not have a corresponding R
script! Now compare this with the main branch in late February 2025 of
the GitHub repository.

``` r
url <- "https://github.com/igraph/rigraph/archive/0bac719e44c18024080163f52fbce373ebd2c26b.tar.gz"
check_test_mapping(url)
```

    [1] 0

🥳

## Conclusion

Test file refactoring does not rank high on the list of exciting things
to do while maintaining an R package. Most users will never see the
result of this effort and it does not directly impact the usability of
the package. However, from a developers perspective, this was a very
important step to ensure long-term maintainability of the package since
it introduces a clear modular test structure for the package that is
easier to comprehend. This means less of a barrier to add and work on
new tests; and importantly means less of a barrier for newcomers to
contribute.

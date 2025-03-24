# Load necessary libraries
library(stringr)
library(fs)

# Set flag to indicate this file has been sourced
render_files <- function(overwrite = FALSE) {

  # Create output directory if it doesn't exist
  fs::dir_create("jekyll/markdown_output/posts", recursive = TRUE)

  # odir <- setwd("jekyll/markdown_output/posts")
  # on.exit(setwd(odir))

  # Find all Quarto files in the posts directory
  quarto_files <- list.files("posts", pattern = "index\\.qmd$", full.names = TRUE, recursive = TRUE)
  
  # Change to the output directory


  render_file <- function(file) {

    post_dir <- "jekyll/markdown_output/posts"
    out_dir <- normalizePath(fs::path(post_dir, basename(dirname(file))))

    if (!overwrite && fs::dir_exists(out_dir)) {
      cat("Skipping", file, "- output already exists\n")
      return(TRUE)
    }

    if (overwrite && fs::dir_exists(out_dir)) {
      fs::dir_delete(out_dir)
    }

    cat("Copying", dirname(file), "to", out_dir, "\n")
    fs::dir_copy(dirname(file), out_dir, overwrite = overwrite)

    if (!overwrite && file.exists(file.path(out_dir, "index.md"))) {
      cat("Skipping", file, "- output already exists\n")
      return(TRUE)
    }

    cat("Rendering", file, "\n")
    # for some reason `index.md` is written to the current working directory
    od <- setwd(out_dir);  on.exit(setwd(od))
    ans <- try(quarto::quarto_render(
      input = "index.qmd", 
      output_format = "markdown",
      output_file = "index.md", 
      profile = "jekyll"  # need this to avoid using the default profile
    ))
    setwd(od)


    if (inherits(ans, "try-error")) {
      cat("Error rendering", file, "\n")
      fs::dir_delete(out_dir)
      return(FALSE)
    }

    # clean up
    fs::file_delete(fs::path(out_dir, "index.qmd"))

    cat("Successfully rendered", file, "\n")
    TRUE
  }

  for (file in quarto_files) {
    message("Rendering", file, "\n")
    try(render_file(file))
  }


}

render_files(overwrite = TRUE)
# convert_mermaid_files()

posts <- list.files("jekyll/markdown_output/posts", pattern = "^\\d{4}-\\d{2}-\\d{2}", full.names = TRUE)
for (post in posts) {
  fs::dir_copy(
    post, 
    file.path("../cynkraweb/www/blog/", basename(post)), 
    overwrite = TRUE
  )
}


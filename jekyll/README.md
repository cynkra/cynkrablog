# cynkrablog: Quarto to Jekyll Conversion

A tool for converting Quarto documents to Jekyll-compatible Markdown files.

## Usage

```r
# Convert all Quarto posts
source("jekyll/convert_qmd_to_md.R")

# Or manually render specific files
render_files(overwrite = TRUE)  # Convert all files, overwriting existing output
render_files(overwrite = FALSE) # Skip files that already have output
```

The script automatically:
- Finds all Quarto posts (`index.qmd` files) in the `posts/` directory
- Converts them to Markdown
- Places output in `jekyll/markdown_output/posts/`
- Copies results to the blog directory

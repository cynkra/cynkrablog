# Quarto to Jekyll Markdown Workflow

This document explains the workflow for generating markdown files from Quarto for later use in Jekyll.

## Overview

The original workflow rendered the Quarto blog directly to HTML. This updated workflow:

1. Executes and renders Quarto documents (.qmd) into GitHub Flavored Markdown (.md) files
2. Preserves all YAML front matter required by Jekyll
3. Maintains all executed code outputs (like plots) as markdown-compatible content
4. Outputs to a separate folder (`markdown_output/`) to avoid conflicts

## How to Run

To render the blog to markdown files:

```bash
./render_to_markdown.sh
```

This will:
1. Create the output directory if it doesn't exist
2. Render all .qmd files to markdown, executing code chunks
3. Place the output in the `markdown_output/` directory

## Configuration Details

The `_quarto.yml` file has been modified to:

- Change the output format from HTML to GitHub Flavored Markdown (GFM)
- Preserve YAML front matter (important for Jekyll)
- Maintain image paths for Jekyll compatibility
- Execute all code chunks

## Using with Jekyll

The generated markdown files in `markdown_output/` can be copied to your Jekyll blog's content directory. The images and other assets will be in the same relative paths as in the Quarto project.

## Notes

- The `preserve-yaml: true` option ensures that Jekyll front matter is kept intact
- Code chunks are executed during rendering, so all plots and outputs are included in the markdown
- Math equations are preserved in their original format for Jekyll processing 
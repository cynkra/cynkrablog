# source of the cynkra blog

### Render

- install [Quarto](https://quarto.org/docs/get-started/);
- run `quarto preview`.

### Markdown Rendering for Jekyll (New Workflow)

If you want to generate markdown files (with code execution) for use in a Jekyll website:

1. Install [Quarto](https://quarto.org/docs/get-started/)
2. Install required R packages with `Rscript install_dependencies.R`
3. Run `./render_to_markdown.sh`
4. The generated markdown files will be available in the `markdown_output/` directory

For more details about this workflow, see [MARKDOWN_WORKFLOW.md](MARKDOWN_WORKFLOW.md).

### Preview Pull Requests

https://cynkra.github.io/cynkrablog

This means two PRs will compete to deploy to the same link (https://github.com/cynkra/cynkrablog/issues/54).

### Fonts

The cynkra blog uses the same fonts from [cynkra/cynkraweb on GitHub](https://github.com/cynkra/cynkraweb/blob/main/www/user/_fonts.scss), specifically `font-family: "frutiger", sans-serif;` with font weights of `300` (light), `400` (normal), and `700` (bold). Please ensure not to use **500**, **600**, **bolder**, or other weights, as the browser would render them using faux styles.

Keep in mind that since the Cynkra blog loads fonts from absolute URLs (e.g. `src: url("https://cynkra.com/assets/css/fonts/6135829/b05d44ef-6a78-4aa4-9388-3f0e05252a48.woff2") format("woff2");`), if there is a font update at the [cynkra/cynkraweb GitHub repository](https://github.com/cynkra/cynkraweb/), the URLs might change, requiring updates on our end as well.

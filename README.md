# source of the cynkra blog

To render,

- install [Quarto](https://quarto.org/docs/get-started/);
- run `quarto render`;
- the output is in `docs/`. To serve the folder, in R you can use `servr::httw("docs")`.

## Fonts

The cynkra blog uses the same fonts from [cynkra/cynkraweb on GitHub](https://github.com/cynkra/cynkraweb/blob/main/www/user/_fonts.scss), specifically `font-family: "frutiger", sans-serif;` with font weights of `300` (light), `400` (normal), and `700` (bold). Please ensure not to use **500**, **600**, **bolder**, or other weights, as the browser would render them using faux styles.

Keep in mind that since the Cynkra blog loads fonts from absolute URLs (e.g. `src: url("https://cynkra.com/assets/css/fonts/6135829/b05d44ef-6a78-4aa4-9388-3f0e05252a48.woff2") format("woff2");`), if there is a font update at the [cynkra/cynkraweb GitHub repository](https://github.com/cynkra/cynkraweb/), the URLs might change, requiring updates on our end as well.
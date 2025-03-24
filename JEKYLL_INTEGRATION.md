# Integrating with Jekyll

This document provides instructions for using the markdown files generated from Quarto in a Jekyll website.

## Overview

The `render_to_markdown.sh` script generates GitHub Flavored Markdown (GFM) files from Quarto documents. These markdown files:

1. Have all code chunks executed
2. Preserve YAML front matter needed for Jekyll
3. Include all images and assets in the output directory
4. Are ready to be used in a Jekyll site

## Directory Structure

After running the script, you'll have:

```
markdown_output/
├── posts/
│   ├── 2020-08-25-git-multiple-identities/
│   │   ├── index.md
│   │   └── ... (images)
│   ├── 2021-07-09-certified-partner-anniversary/
│   │   ├── index.md
│   │   └── ... (images)
│   └── ...
└── mountain.jpg
```

## Steps to Integrate with Jekyll

1. **Copy the markdown files**: Copy the contents of the `markdown_output/` directory to your Jekyll site's content directory (typically `_posts/` or a custom collection directory).

2. **Configure Jekyll for post structure**: Update your Jekyll configuration to recognize the directory structure. If you're using a custom collection for blog posts, add to your `_config.yml`:

   ```yaml
   collections:
     posts:
       output: true
       permalink: /:year/:month/:day/:title/
   ```

3. **Adjust front matter if needed**: The markdown files already have YAML front matter, but you might need to adjust some fields depending on your Jekyll theme.

4. **Fix image paths**: The image paths in the markdown files are relative to the post directory. Make sure your Jekyll configuration handles these correctly. You might need to add this to your `_config.yml`:

   ```yaml
   include:
     - posts
   ```

5. **Test your site**: Run `jekyll serve` to test your site with the new content.

## Jekyll Customization

Depending on your Jekyll setup, you might need to:

1. Create or adjust layouts to match the `layout: post` reference in the front matter
2. Configure categories handling
3. Customize CSS for specific content like code blocks and images
4. Configure syntax highlighting for code blocks

## Automating the Process

For an automated workflow:

1. Run `./render_to_markdown.sh` to generate the markdown files
2. Use a script to copy the files to your Jekyll site
3. Build and deploy your Jekyll site

This can be part of a CI/CD pipeline for automatic updates.

## Troubleshooting

- **Missing images**: Check the image paths in the markdown files and ensure Jekyll is configured to serve files from the post directories
- **YAML parsing errors**: Ensure there are no syntax errors in the front matter
- **Code syntax highlighting**: Jekyll uses Rouge by default; you may need to configure it to match the code styles from Quarto 
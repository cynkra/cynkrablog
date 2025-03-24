#!/bin/bash

# Script to render Quarto blog to markdown files for Jekyll

set -eo pipefail

# Check if Quarto is installed
if ! command -v quarto &> /dev/null; then
    echo "Error: Quarto is not installed or not in your PATH"
    echo "Please install Quarto from https://quarto.org/docs/get-started/"
    exit 1
fi

# Ensure output directory exists
mkdir -p markdown_output

# Define problematic posts that we should skip
SKIP_POSTS=(
  "posts/2024-09-16-blockr/index.qmd"
)

# Define posts that need special handling
SPECIAL_POSTS=(
  "posts/2024-09-09-zurich-roadcycling-wc-2024/index.qmd"
)

# Define posts that contain Mermaid diagrams (requiring JS in Jekyll)
MERMAID_POSTS=(
  "posts/2025-02-07-r-agents/index.qmd" 
)

# Function to check if a path should be skipped
should_skip() {
  local path="$1"
  for skip_path in "${SKIP_POSTS[@]}"; do
    if [[ "$path" == *"$skip_path"* ]]; then
      return 0  # True, should skip
    fi
  done
  return 1  # False, should not skip
}

# Function to check if a post needs special handling
is_special_post() {
  local path="$1"
  for special_path in "${SPECIAL_POSTS[@]}"; do
    if [[ "$path" == *"$special_path"* ]]; then
      return 0  # True, needs special handling
    fi
  done
  return 1  # False, standard handling
}

# Function to check if a post contains mermaid diagrams
has_mermaid() {
  local path="$1"
  for mermaid_path in "${MERMAID_POSTS[@]}"; do
    if [[ "$path" == *"$mermaid_path"* ]]; then
      return 0  # True, has mermaid diagrams
    fi
  done
  return 1  # False, no mermaid diagrams
}

# Render individual posts with appropriate handling
echo "Rendering each post individually for better control..."
for post in posts/*/index.qmd; do
  if should_skip "$post"; then
    echo "Skipping problematic post: $post"
    continue
  elif is_special_post "$post"; then
    echo "Special handling for post: $post"
    if [[ "$post" == *"zurich-roadcycling-wc-2024"* ]]; then
      # Special handling for the roadcycling post with prefer-html
      (cd $(dirname "$post") && quarto render index.qmd --to gfm) || {
        echo "WARNING: Special handling for $post failed, skipping..."
      }
    else
      # Default special handling for other special posts
      quarto render "$post" --to gfm --execute=false || {
        echo "WARNING: Special handling for $post failed, skipping..."
      }
    fi
  else
    echo "Rendering: $post"
    # Standard rendering for regular posts
    quarto render "$post" --to gfm || {
      echo "WARNING: Rendering of $post failed, skipping..."
    }
  fi
  
  # Check if post contains mermaid diagrams and add a note
  if has_mermaid "$post"; then
    echo "NOTE: Post $post contains Mermaid diagrams."
    echo "      To render Mermaid diagrams in Jekyll, you need to add the Mermaid JavaScript library."
    echo "      Add the following to your Jekyll layout:"
    echo "      <script src=\"https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js\"></script>"
    echo "      <script>mermaid.initialize({startOnLoad:true});</script>"
  fi
done

# Render main index.qmd if it exists
if [ -f "index.qmd" ]; then
  echo "Rendering main index.qmd..."
  quarto render "index.qmd" --to gfm
fi

# Success message
echo "Rendering complete! Markdown files are available in markdown_output/"
echo "You can now use these markdown files in your Jekyll website."

# Mermaid diagrams warning
echo ""
echo "NOTE: Some posts contain Mermaid diagrams which require JavaScript to render in Jekyll."
echo "To render Mermaid diagrams, add the following to your Jekyll layout:"
echo "<script src=\"https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js\"></script>"
echo "<script>mermaid.initialize({startOnLoad:true});</script>" 
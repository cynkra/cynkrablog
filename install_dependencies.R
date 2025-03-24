# Install packages needed for the blog posts

# List of packages used in the blog
cran_packages <- c(
  "seasonal",          # For seasonal adjustment posts
  "ggplot2",           # For data visualization
  "knitr",             # For R markdown processing
  "rmarkdown",         # For R markdown 
  "dplyr",             # For data manipulation
  "tidyr",             # For data tidying
  "xml2",              # For XML processing
  "pracma",            # For practical math functions (used in blockr post)
  "palmerpenguins",    # For dataset in blockr post
  "remotes",           # For installing GitHub packages
  "gtable",            # For blockr post
  "scales",            # For blockr post
  "gpx",               # For roadcycling post
  "leaflet",           # For roadcycling post
  "leaflet.extras",    # For roadcycling post
  "sf",                # For spatial data
  "htmltools",         # For HTML widgets
  "htmlwidgets",       # For HTML widgets
  "patchwork"          # For combining plots
)

github_packages <- c(
  "BristolMyersSquibb/blockr",             # Main blockr package
  "BristolMyersSquibb/blockr.ggplot2",     # blockr extension
  "insightsengineering/roxy.shinylive"     # For Shiny apps in markdown
)

# Install missing CRAN packages
new_packages <- cran_packages[!(cran_packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) {
  install.packages(new_packages, repos = "https://cloud.r-project.org")
}

# Install GitHub packages
if(length(github_packages) > 0) {
  if(!require(remotes)) {
    install.packages("remotes", repos = "https://cloud.r-project.org")
  }
  
  for(pkg in github_packages) {
    pkg_name <- gsub(".*/", "", pkg)
    if(!require(pkg_name, character.only = TRUE)) {
      tryCatch({
        remotes::install_github(pkg)
      }, error = function(e) {
        message(paste("Failed to install", pkg, ":", e$message))
      })
    }
  }
}

# Print installed packages
cat("Installed CRAN packages:\n")
installed <- cran_packages[cran_packages %in% installed.packages()[,"Package"]]
if(length(installed) > 0) {
  cat(paste(" -", installed, collapse = "\n"), "\n")
} else {
  cat("None\n")
}

cat("\nInstalled GitHub packages:\n")
installed_gh <- sapply(github_packages, function(pkg) {
  pkg_name <- gsub(".*/", "", pkg)
  if(pkg_name %in% installed.packages()[,"Package"]) {
    return(pkg)
  } else {
    return(NA)
  }
})
installed_gh <- installed_gh[!is.na(installed_gh)]
if(length(installed_gh) > 0) {
  cat(paste(" -", installed_gh, collapse = "\n"), "\n")
} else {
  cat("None\n")
}

# Print missing packages (if any)
cat("\nPackages that could not be installed:\n")
missing_cran <- cran_packages[!(cran_packages %in% installed.packages()[,"Package"])]
missing_gh <- sapply(github_packages, function(pkg) {
  pkg_name <- gsub(".*/", "", pkg)
  if(!(pkg_name %in% installed.packages()[,"Package"])) {
    return(pkg)
  } else {
    return(NA)
  }
})
missing_gh <- missing_gh[!is.na(missing_gh)]
missing <- c(missing_cran, missing_gh)
if(length(missing) > 0) {
  cat(paste(" -", missing, collapse = "\n"), "\n")
} else {
  cat("None\n")
} 
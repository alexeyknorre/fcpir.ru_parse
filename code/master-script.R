# install pacman to streamline further package installation
if (!require("pacman", character.only = TRUE)){
  install.packages("pacman", dep = TRUE)
  if (!require("pacman", character.only = TRUE))
    stop("Package not found")
}


# these are the required packages
pkgs <- c(
  "tidyverse", 
  "openxlsx",
  "rvest")

# install the missing packages
# only run if at least one package is missing
if(!sum(!p_isinstalled(pkgs))==0){
  p_install(
    package = pkgs[!p_isinstalled(pkgs)], 
    character.only = TRUE
  )
}

# Create folders
dir.create("data"), showWarnings = FALSE)
dir.create("results"), showWarnings = FALSE)

# Run scripts
eval(parse("code/1_parse_links.R", encoding = "UTF-8"))
eval(parse("code/2_parse_details.R", encoding = "UTF-8"))
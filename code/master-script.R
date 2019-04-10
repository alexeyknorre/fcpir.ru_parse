# check nedded libraries
if (!require("tidyverse", character.only = TRUE)){
  install.packages("tidyverse", dep = TRUE)
}

if (!require("openxlsx", character.only = TRUE)){
  install.packages("openxlsx", dep = TRUE)
}

if (!require("rvest", character.only = TRUE)){
  install.packages("rvest", dep = TRUE)
}


# Create folders
dir.create("data", showWarnings = FALSE)
dir.create("results", showWarnings = FALSE)

# Run scripts
eval(parse("code/1_parse_links.R", encoding = "UTF-8"))
eval(parse("code/2_parse_details.R", encoding = "UTF-8"))
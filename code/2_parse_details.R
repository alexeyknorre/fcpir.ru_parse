library(tidyverse)
library(rvest)
library(openxlsx)

df <- readRDS("data/project_links.rds")

# Function that extracts project details
get_project_details <- function(project_url){
  project_row <- read_html(project_url) %>%
    html_table(fill=T) %>% .[[1]] %>% .[1:14,2]
  
  project_row[12:14] <- gsub("\n.*","",project_row[12:14])
  
  c(project_row, project_url)
}


# Create empty data.frame
cols <- 
  c("number",
    "topic",
    "status",
    "application code",
    "organization",
    "director",
    "date_signed",
    "date_job_start",
    "date_job_end",
    "priority_direction",
    "program_event",
    "budget",
    "nonbudget",
    "job_stages",
    "url")

projects <- data.frame(matrix(ncol = length(cols),
                              nrow = nrow(df)))
names(projects) <- cols


# Extract project details for every project
for (i in 1:nrow(df)) {
  print(paste0(i,"/",nrow(df)))
  projects[i,] <- get_project_details(df$url[i])
}

# Save
write.xlsx(projects, file = "results/projects.xlsx")

rm(list = ls())


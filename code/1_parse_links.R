library(tidyverse)
library(rvest)


## Get project links

# Category 1.2: code 13787
# Category 1.4: code 13805

# Function to get list of project links by category

get_projects_by_category <- function(projects_category_id, project_category)
{
  projects_url <- paste0(
    "http://www.fcpir.ru/participation_in_program/contracts/?contractsFilter_ff%5BCODE%5D=&contractsFilter_pf%5BPROGRAM_ACTION%5D=",
    projects_category_id,
    "&contractsFilter_pf%5BLEADING_SUB_PRIORITY_LINE%5D=&contractsFilter_pf%5BFULL_TITLE%5D=&contractsFilter_pf%5BEND_YEAR%5D=&contractsFilter_pf%5BORGANIZATION_NAME%5D=&set_filter=Y&PAGEN_1="
    )
max_page <- read_html(paste0(projects_url,"1")) %>% 
  html_node(".pagination") %>%
  html_nodes("a") %>%
  html_text() %>% 
  as.integer() %>% 
  max(.,na.rm = T)

get_project_ids <- function(page){
  url_page <- paste0(projects_url, page)
  read_html(url_page) %>% html_node("tbody") %>%  html_nodes("tr") %>% 
    html_node("td") %>% html_node("a") %>% html_attr("href")
}

project_ids <- c()

for (page_number in 1:max_page) {
  print(paste0(page_number,"/",max_page))
  project_ids <- c(project_ids, get_project_ids(page_number))
}

project_df <- data.frame(url = project_ids,
                         category = project_category,
                         stringsAsFactors = F)
return(project_df)
}

# Get lists of project links for two categories
df <- rbind(get_projects_by_category(13787, "1.2"),
           get_projects_by_category(13805, "1.4"))

df$url <- paste0("http://www.fcpir.ru",df$url)

# save
saveRDS(df, "data/project_links.rds")

rm(list = ls())

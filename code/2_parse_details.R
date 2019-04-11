library(tidyverse)
library(rvest)
library(openxlsx)

mapping <- data.frame(ru = c("Номер", "Тема", "Состояние", "Шифр заявки",
  "Организация Головной исполнитель", 
  "Руководитель работ", "Дата подписания", "Дата начала работ", 
  "Дата окончания работ", "Основное приоритетное направление", 
  "Программное мероприятие", "Бюджет, Итого (млн.руб)",
  "Внебюджет, Итого (млн.руб)", 
  "Этапы выполнения работ"),
  en =   c("number", "topic", "status", "application code",
           "organization", "director", "date_signed",
           "date_job_start",  "date_job_end",
           "priority_direction", "program_event",
           "budget",  "nonbudget", "job_stages"),
  stringsAsFactors = F)

df <- readRDS("data/project_links.rds")

# Function that extracts project details

get_project_details <- function(project_url){
  project_row <- read_html(project_url) %>%
    html_table(fill=T) %>% .[[1]] %>% 
    .[,1:2]
  
  project_row[,2] <- gsub("\n.*","",project_row[,2])
 
  project_row <- map(mapping$ru,
              ~ project_row[project_row[1] == .,2])
  
  project_row <- unlist(lapply(project_row,
                function(x) if(identical(x,character(0))) ' ' 
                                 else x))
  
  c(project_row, project_url)
}


projects <- data.frame(matrix(ncol = nrow(mapping)+1,
                              nrow = nrow(df)))
names(projects) <- c(mapping$en, "url")


# Extract project details for every project
for (i in 1:nrow(df)) {
  print(paste0(i,"/",nrow(df)))
  projects[i,] <- get_project_details(df$url[i])
}

# Save
write.xlsx(projects, file = "results/projects.xlsx")

rm(list = ls())


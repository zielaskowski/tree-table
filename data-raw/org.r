library(magrittr)
library(readr)
library(data.tree)
library(tidyr)
library(dplyr)


## code to prepare `org` dataset
#import data
org <- read_csv(file="./data-raw/org.csv") %>%
  mutate(data=paste0(year,"-",month)) %>%
  select(-year,-month) %>%
  pivot_wider(names_from = data, values_from = value, values_fill = list(value=0))

org <- FromDataFrameTable(org,pathName = "org_path", pathDelimiter = "/")


usethis::use_data(org, overwrite = TRUE)

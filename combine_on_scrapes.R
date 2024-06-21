rm(list = ls())

library(tidyverse)
library(readr)
library(tidyr)

scrape1 <- read_csv("doctors_info_on.csv")
scrape2 <- read_csv("doctors_info_on_specialties.csv")

uniquelink <- scrape1 %>% group_by(Link) %>%
  summarize(
    n = n()
  ) %>% filter(n==2)

#note there are some duplicates but overall not a huge concern
duplicates <- scrape1 %>% filter(Link %in% uniquelink$Link)

combine_scraped <- scrape1 %>%
  left_join(
    scrape2,
    join_by(Link, Name),
    relationship = "many-to-one"
  ) %>%
  mutate(
    city = sapply(str_split(PPAddress, ",\\s*"), function(x) {
      on_index <- which(x == "ON")
      if (length(on_index) == 0) {
        NA_character_
      } else {
        x[on_index - 1]
      }
    })
  )

write_csv(combine_scraped, "doctors_info_ON_combined.csv")




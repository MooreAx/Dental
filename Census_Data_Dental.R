library(tidyverse)
library(readr)
library(tidyr)

fldr <- "C:/Users/moore/OneDrive/Work/ReginaDental/CensusData"

#prov data
Census1 <- read_csv(
  paste(fldr, "Prov", "98-401-X2021001_English_CSV_data.csv", sep = "/")
) %>%
  filter(
    GEO_LEVEL == "Province"
  )

Census_Prov <- Census1 %>%
  filter(
    CHARACTERISTIC_ID %in% seq(8, 33)
  ) %>%
  select(CENSUS_YEAR, GEO_LEVEL, GEO_NAME, CHARACTERISTIC_ID, CHARACTERISTIC_NAME, C1_COUNT_TOTAL) %>%
  filter(
    CHARACTERISTIC_ID %in% c(8, 10, 11, 12, 14)
  ) %>%
  select(-CHARACTERISTIC_ID) %>%
  pivot_wider(
    names_from = CHARACTERISTIC_NAME,
    values_from = C1_COUNT_TOTAL,
    names_repair = "universal"
  ) %>%
  rename(
    Total = 4
  ) %>%
  rowwise() %>%
  mutate(
    Age0to19 = sum(c_across(5:8)),
    Age0to19Rate = Age0to19 / Total
  )


#CMA data
Census2 <- read_csv(
  paste(fldr, "CMA", "98-401-X2021002_English_CSV_data.csv", sep = "/"),
  locale = locale(encoding = "Windows-1252")
) %>%
  filter(
    GEO_LEVEL == "Census metropolitan area"
  )

Census_CMA <- Census2 %>%
  filter(
    CHARACTERISTIC_ID %in% seq(8, 33)
  ) %>%
  select(CENSUS_YEAR, GEO_LEVEL, GEO_NAME, CHARACTERISTIC_ID, CHARACTERISTIC_NAME, C1_COUNT_TOTAL) %>%
  filter(
    CHARACTERISTIC_ID %in% c(8, 10, 11, 12, 14)
  ) %>%
  select(-CHARACTERISTIC_ID) %>%
  pivot_wider(
    names_from = CHARACTERISTIC_NAME,
    values_from = C1_COUNT_TOTAL,
    names_repair = "universal"
  ) %>%
  rename(
    Total = 4
  ) %>%
  rowwise() %>%
  mutate(
    Age0to19 = sum(c_across(5:8)),
    Age0to19Rate = Age0to19 / Total
  )

ggplot(Census_CMA, aes(x=Age0to19, y = reorder(GEO_NAME, desc(Age0to19)))) +
  geom_col() +
  scale_x_continuous(labels = scales::comma) +
  #scale_x_continuous(trans = "log10", labels = scales::comma) + 
  labs(
    title = "2021 Census Data",
    x = "Population < 19 years",
    y = "Census Metropolitan Area"
  )


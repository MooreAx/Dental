rm(list = ls())

library(tidyverse)
library(readr)
library(tidyr)
library(readxl)


Input <- read_xlsx(
  "Codes_Data_Input.xlsx",
  .name_repair = "universal")
  

# Apply Transformations

Output <- Input %>%
  
  #remove rows flagged for delete
  replace_na(list(Delete. = 0)) %>%
  filter(Delete. == 0) %>%
  select(-Delete.) %>%
  
  
  #replace $ nas with zero
  replace_na(list(PatAmt = 0, InsAmt = 0, TotAmt = 0, PatTot = 0)) %>%

  #remove unneeded columns
  select(-c(InsOverride, Flag, FlagNote))


#Patient Visits
PV <- Output %>% distinct(Date, ID, DayType)

#PV flagged as recall
Recalls <- Output %>%
  select(Date, ID, DayType, Recall.PV) %>%
  drop_na() %>%
  unique()

#PV flagged as consult
Consults <- Output %>%
  select(Date, ID, DayType, Consult.PV) %>%
  drop_na() %>%
  unique()
  

PV <- PV %>%
  left_join(
    Recalls,
    join_by(Date, ID, DayType),
    relationship = "one-to-one"
  ) %>%
  left_join(
    Consults,
    join_by(Date, ID, DayType),
    relationship = "one-to-one"
  ) %>%
  replace_na(list(Recall.PV = 0, Consult.PV = 0)) %>%
  mutate(
    Type = case_when(
      DayType == "OR" ~ "OR",
      DayType == "clinic" & Recall.PV == 1 ~ "Recall",
      DayType == "clinic" & Consult.PV == 1 ~ "Consult",
      DayType == "clinic" & Consult.PV == 0 & Recall.PV == 0 ~ "TX",
      .default = "Other"
    )
  ) %>%
  select(-c(Consult.PV,Recall.PV))

#Insurance type = Gov't if at least 1 code in the PV is Gov't

GovtPVs <- Output %>%
  filter(InsType == "Gov't") %>%
  select(Date, ID, DayType, InsType) %>%
  distinct()

PV <- PV %>%
  left_join(
    GovtPVs,
    join_by(Date, ID, DayType),
    relationship = "one-to-one"
  ) %>%
  replace_na(list(InsType = "Private")) %>%
  rename(PVInsType = InsType)

CleanCodes <- Output %>%
  left_join(
    PV,
    join_by(Date, ID, DayType),
    relationship = "many-to-one"
  ) %>%
  arrange(Date, ID, Description) %>%
  select(-c(Recall.PV, Consult.PV)) %>%
  mutate(
    Date = as.Date(Date)
  )


write_csv(CleanCodes, "Codes_Data_Output.csv")



             
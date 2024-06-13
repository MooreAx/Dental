# Load necessary packages
library(ggmap)
library(tidyverse)
library(readr)
library(tidyr)

#get private keys
source("PrivateKeys.R")

register_stadiamaps(key = StadiaAPIKey)
register_google(key = GoogleAPIKey)

Dentists <- read_csv("doctors_info.csv")

#create function
proceed_with_geocoding <- function() {
  response <- menu(c("Yes", "No"), title = "\n\n\nWarning: Google API calls cost money. Proceed?")
  return(response == 1) #returns true if the user selects Yes
}

# Wrap the geocoding process
if (proceed_with_geocoding()) {
  Dentists_geocoded <- Dentists %>%
    mutate(geocode_result = geocode(Address, source = "google")) %>%
    
    #produces a list column. unnest it
    unnest_wider(geocode_result, names_sep = "_")
  
  write_csv(Dentists_geocoded, "Dentists_geocode_20240612.csv")
  
} else {
  cat("Geocoding process aborted.\n")
}

  
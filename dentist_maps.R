# Load necessary packages
library(ggmap)
library(tidyverse)
library(readr)
library(tidyr)

Dentists_geocoded <- read_csv("Dentists_geocoded_20240612.csv") %>%
  rename(
    lon = address_lon,
    lat = address_lat
  )

#get private keys
source("PrivateKeys.R")

register_stadiamaps(key = StadiaAPIKey)


regina_map <- get_stadiamap(
  bbox = c(left = -104.7, bottom = 50.4, right = -104.5, top = 50.50),
  maptype = "stamen_toner_lite", zoom = 13
)

# Plot the map with the points
plot <- ggmap(regina_map) +
  geom_point(data = Dentists_geocoded, aes(x = lon, y = lat, color = Practice), size = 2, stroke = 2) +
  labs(title = "Dentists in Regina by CDSS Address", x = "Longitude", y = "Latitude") +
  scale_shape_manual()

print(plot)

ggsave("ReginaDentists.pdf", plot, dpi = 300, width = 16, height = 12)



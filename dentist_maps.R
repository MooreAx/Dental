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

regina <- c(left = -104.7, bottom = 50.4, right = -104.5, top = 50.50)
saskatoon <- c(left = -106.78, bottom = 52.07, right = -106.52, top = 52.2)

regina_map <- get_stadiamap(
  bbox = regina,
  maptype = "stamen_toner_lite", zoom = 13
)

saskatoon_map <- get_stadiamap(
  bbox = saskatoon,
  maptype = "stamen_toner_lite", zoom = 13
)

# Plot the map with the points
plot_regina <- ggmap(regina_map) +
  geom_point(data = Dentists_geocoded, aes(x = lon, y = lat, color = Practice), size = 2, stroke = 2) +
  labs(title = "Dentists in Regina by CDSS Address", x = "Longitude", y = "Latitude") +
  scale_shape_manual()

plot_saskatoon <- ggmap(saskatoon_map) +
  geom_point(data = Dentists_geocoded, aes(x = lon, y = lat, color = Practice), size = 2, stroke = 2) +
  labs(title = "Dentists in Saskatoon by CDSS Address", x = "Longitude", y = "Latitude") +
  scale_shape_manual()


print(plot_saskatoon)

ggsave("ReginaDentists.pdf", plot, dpi = 300, width = 16, height = 12)



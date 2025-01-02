##Plot census metropolitan areas

#install.packages("sf")
library(sf)
library(tidyverse)
library(ggplot2)

cma <- read_sf("GeoCensus/lcma000b21a_e/lcma000b21a_e.shp")

prov <- read_sf("GeoCensus/lpr_000b21a_e/lpr_000b21a_e.shp")

ggplot(cma)+
  geom_sf(fill = "red", color="white")

ggplot(prov)+
  geom_sf(fill = "red", color="white")



ggplot() +
  geom_sf(data = prov, fill = NA, color = "black") +  # Plot provinces with borders only
  geom_sf(data = cma, fill = "red", color = "white") +  # Plot CMAs with color fill
  geom_sf_text(data = cma, aes(label = CMANAME), size = 2) +  # Label CMAs with small text
  theme_minimal() +
  labs(title = "Census Metropolitan Areas within Provinces",
       fill = "CMA")


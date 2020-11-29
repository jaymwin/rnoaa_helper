
library(tidyverse)
library(rnoaa)
library(lubridate)

source(here::here('rnoaa_functions.R'))

# download weather data ---------------------------------------------------

# need key to use rnoaa
options(noaakey = '***')

# data from 2000-2020, Boise airport
years <- seq(2000, 2020, 1)
station_id <- 'GHCND:USW00024131'

# request data
rnoaa_weather_dat <- rnoaa_helper(years, station_id)

# plot
rnoaa_weather_dat %>%
  ggplot() +
  geom_line(aes(date, tavg)) +
  theme_minimal()
ggsave(here::here('tavg_1980_2020.png'), width = 4, height = 3, units = 'in')

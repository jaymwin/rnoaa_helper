
# extract daily weather for a single year
get_daily_weather <- function(df) {
  
  # get daily temps from station
  temps <- ncdc(
    datasetid = 'GHCND',
    stationid = df$station,
    datatypeid = c('TMAX', 'TMIN'),
    startdate = df$start_date,
    enddate = df$end_date,
    limit = 1000
  )
  
  # turn into tibble, convert 1/10s of C to C
  temps <- temps$data %>%
    as_tibble() %>%
    mutate(
      value = value/10,
      date = as.Date(str_sub(date, start = 1, end = 10))
    ) %>%
    mutate(
      year = year(date),
      month = month(date)
    ) %>%
    select(-matches('fl')) %>%
    pivot_wider(values_from = value, names_from = datatype) %>%
    rename(
      tmax = TMAX,
      tmin = TMIN
    ) %>%
    mutate(tavg = (tmax + tmin) / 2)
  
}

# apply function above to each year requested
rnoaa_helper <- function(years, station) {
  
  df <- tibble(
    station = station_id,
    year = years
  ) %>%
    mutate(
      start_date = paste(year, '01-01', sep = '-'),
      end_date = paste(year, '12-31', sep = '-')
    ) %>%
    group_by(year) %>%
    nest() %>%
    mutate(weather_df = map(data, get_daily_weather)) %>%
    ungroup() %>%
    select(weather_df) %>%
    unnest()
  
}
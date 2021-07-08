# Berlin R user group meetup, 
# Coding Challenge, Oct 29, 2019
# Knut Behrends
library(MASS) # rlm
library(tidyverse)
theme_set(theme_bw())
# open data source:  
# https://luftdaten.berlin.de/pollution/pm10?stationgroup=background&period=24h&timespan=custom&start%5Bdate%5D=01.01.2018&end%5Bdate%5D=31.12.2018
pm2018 <- read_delim("~/Downloads/ber_pm10_20180101-20181231.csv",
                     delim = ";", skip=3) 
pm1999 <- read_delim("~/Downloads/ber_pm10_19990101-19991231.csv",
                     delim = ";", skip=3) 

head(pm2018)
head(pm1999)
mean_1999 <- mean(pm1999$Tageswerte, na.rm = TRUE)
mean_2018 <- mean(pm2018$Tageswerte, na.rm = TRUE)

pm2018_gath <- pm2018 %>% 
  mutate(day = lubridate::dmy(Messzeit)) %>%
  select(-Messzeit) %>%
  gather(k, v, -day) %>%
  filter (k == "Tageswerte") %>%
  mutate(year = 2018,  avg = mean_2018)

pm1999_gath <- pm1999 %>% 
  mutate(day = lubridate::dmy(Messzeit)) %>%
  select(-Messzeit) %>%
  gather(k, v, -day) %>%
  mutate(year = 1999, avg = mean_1999)


pm <- bind_rows(pm1999_gath, pm2018_gath)
head(pm)

pm %>%
  ggplot(aes(day, v, group=k, color = as.factor(year))) +
    geom_line() +
  geom_smooth(method = "rlm", se =FALSE, 
              color = "black", linetype = 1, size = 0.5) +
  facet_wrap(~ year, scales = "free_x", nrow = 2) +
  theme(legend.position = "none") +
  labs(title = "Luftverschmutzung in Berlin",
       subtitle = "Feinstaub pm10, µg/m³, 1999 vs 2018.\nSchwarze Linien: Modell-Fit, MASS::rlm Funktion",
       x = "", y = "")

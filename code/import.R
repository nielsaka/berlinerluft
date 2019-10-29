library(tidyverse)



ber_mw088_2018 <- read.csv2('./in/ber_mw088_20180101-20181231.csv',
                            stringsAsFactors = FALSE)

colnames(ber_mw088_2018) <- as.character(unlist(ber_mw088_2018[1,]))
colnames(ber_mw088_2018)[1] <- "Uhrzeit"

ber_mw088_2018 %<>% mutate(Uhrzeit = as.POSIXct(Uhrzeit,
                                                format = "%d.%m.%Y %H:%M")) %>%
  filter(!is.na(Uhrzeit))


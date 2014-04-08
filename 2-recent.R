library(dplyr)
library(lubridate)
library(ggplot2)

cranatics <- readRDS("cranatics.rds")

# Only look at last six months -------------------------------------------------
recent <- cranatics %.% filter(week > today() - months(6))

by_hour <- recent %.% 
  group_by(wday, hour, uname) %.% 
  tally() %.%
  mutate(prop = n / sum(n))

ggplot(by_hour, aes(hour, prop, colour = uname)) + 
  geom_line(size = 1) + 
  facet_wrap(~ wday)

# Need to smooth and add 0s
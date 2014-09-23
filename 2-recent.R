library(dplyr)
library(lubridate)
library(ggplot2)

cranatics <- readRDS("cranatics.rds")

# Only look at last six months -------------------------------------------------
# And drop Achim since he accepts so few packages

recent <- cranatics %>% 
  filter(week > today() - months(6), uname != "zeileis")

# Long-term trends are weak
by_day <- recent %>%
  group_by(date, uname) %>%
  tally()
ggplot(by_day, aes(date, n, colour = uname)) + geom_line()
ggplot(by_day, aes(date, n, colour = uname)) + 
  geom_line() + 
  geom_smooth(size = 1, se = F)

# My hypothesis is that weekday and hour will have largest
# explanatory power
by_hour <- recent %>% 
  group_by(wday, hour, uname) %>% 
  tally()

# Add in zeros
grid <- expand.grid(
  wday = unique(by_hour$wday),
  hour = unique(by_hour$hour), 
  uname = unique(by_hour$uname)
)
by_hour <- left_join(grid, by_hour) %>%
  mutate(n = ifelse(is.na(n), 0, n))  

ggplot(by_hour, aes(hour, n, colour = uname)) + 
  geom_line(size = 1) + 
  facet_wrap(~ wday)

# Try a little smoothing
ggplot(by_hour, aes(hour, n, colour = uname)) + 
  geom_smooth(size = 1, se = FALSE, method = "loess", span = 0.30) + 
  facet_wrap(~ wday)

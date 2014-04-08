library(dplyr)
library(lubridate)
library(ggplot2)

cranatics <- readRDS("cranatics.rds")

weekly <- cranatics %.% 
  group_by(week, uname) %.% 
  tally()
qplot(week, n, data = weekly, geom = "line", colour = uname)
# Looks like change around 2006 - only after that do we actually
# get useful uname information

weekly <- cranatics %.% 
  filter(week > as.Date("2006-05-21"), uname != "root") %.%
  group_by(week, uname) %.% 
  tally()
qplot(week, n, data = weekly, geom = "line", colour = uname)
# Shift to multiple people at start of 2012

multi <- weekly %.% filter(week > as.Date("2012-01-01"))
qplot(week, n, data = multi, geom = "line", colour = uname)

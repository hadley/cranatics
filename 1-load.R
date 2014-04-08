library(dplyr)
library(lubridate)
library(ggplot2)

base_url <- contrib.url("http://cran.rstudio.com", "source")
download.file(file.path(base_url, "Meta", "current.rds"), "current.rds", quiet = TRUE)
download.file(file.path(base_url, "Meta", "archive.rds"), "archive.rds", quiet = TRUE)

current <- readRDS("current.rds")
archive <- readRDS("archive.rds")

all <- rbind(rbind_all(archive), current)
all$mtime <- as.POSIXct(strptime(all$mtime, "%Y-%m-%d %H:%M:%S"))
all$hour <- hour(all$mtime)
all$date <- as.Date(all$mtime)
all$week <- floor_date(all$date, "week")
all$wday <- wday(all$date, label = TRUE)

all <- tbl_df(all)

saveRDS(all, "cranatics.rds")

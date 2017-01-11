library(cranlogs)
library(dplyr)
library(lubridate)
library(ggplot2)

packages <- c("RColorBrewer", "viridis")

daily_downloads <- cranlogs::cran_downloads(
  packages = packages,
  from = "2016-01-01", to = "2016-12-31"
)

# Roll up daily downloads into coarser time units
rollup_by_period <- function(downloads, unit = c("week", "month", "quarter")) {
  unit <- match.arg(unit)
  downloads %>%
    mutate(date = ceiling_date(date, unit)) %>%
    group_by(date, package) %>%
    summarise(count = sum(count))
}

# Convert download count from daily to weekly
weekly_downloads <- daily_downloads %>% rollup_by_period()

# Plot weekly downloads, plus trendline
ggplot(weekly_downloads, aes(date, count, color = package)) +
  geom_line() +
  geom_smooth()

# Print summary for each of the compared packages
for (pkg in packages) {
  cat("\n==", pkg, "daily downloads ==\n")
  print(summary(
    daily_downloads %>% filter(package == pkg) %>% .$count
  ))
}

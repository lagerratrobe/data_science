# Connect to Kitty-litter and adwords data sets in SQLite and generate some plots

library(tidyverse)
library(stringr)
library(DBI)
library(RSQLite)
library(lubridate)
library(dplyr)

con = dbConnect(SQLite(), dbname="final_project.db")

# Select all records from new_sales table
salesQuery <- dbSendQuery(con, "SELECT * FROM new_sales")
sales <- dbFetch(salesQuery, n = -1)

# Select all recs and populate data.frame
adwordsQuery <- dbSendQuery(con, "SELECT * FROM new_adwords")
adwords <- dbFetch(adwordsQuery, n = -1)

# Clear the connection
dbClearResult(salesQuery)
dbClearResult(adwordsQuery)

# Set adwords "date" field to be true YMD date type
adwords$date <- ymd(adwords$date)

# Plot an easy one, AdWords clicks per day
pdf("AdWords_daily_clicks.pdf", width=7, height=7)
myplot <- ggplot(data = adwords, mapping = aes(x = date, y = clicks)) +
   geom_point() +
   geom_smooth(method = "lm", se = FALSE) +
   xlab("Jul 2017 - Nov 2017") +
   ylab("AdWord Clicks") +
   ggtitle("Total AdWords Clicks per Day")
plot(myplot)
dev.off()

# I want to summarize daily data by week.  How do I do that?
# Add "week" column to adwords
print("--------------------- Adwords with week")
#adwords$week <- format(adwords$date, "%W")
adwords$week <- lubridate::isoweek(adwords$date)
glimpse(adwords)
print("----")

# Need to eliminate first and last weeks (26 and 46) because they look like partials
sliced_adwords <- filter(adwords, week != "26", week != "46")

print("---------------------- Adwords clicks and cost grouped-by Week")
adwords_by_week <- sliced_adwords %>% group_by(week)
adwords_sum_by_week <- adwords_by_week %>% summarize(
    clicks = sum(clicks),
    cost = sum(cost)
    )
glimpse(adwords_sum_by_week)
print("------")

# Plot clicks per week as a barchart
pdf("AdWords_weekly_clicks_bar.pdf", width=7, height=7)
myplot <- ggplot(data = adwords_sum_by_week, mapping = aes(x = week, y = clicks)) +
   geom_col() +
   xlab("Week from Jul 3, 2017 - Nov 12, 2017") +
   ylab("AdWord Clicks") +
   ggtitle("Total AdWords Clicks per Week")
plot(myplot)
dev.off()

# Plot clicks per week as a dot plot
pdf("AdWords_weekly_clicks_line.pdf", width=7, height=7)
myplot <- ggplot(data = adwords_sum_by_week, mapping = aes(x = week, y = clicks)) +
  geom_line() +
   geom_point() +
   xlab("Week from Jul 3, 2017 - Nov 12, 2017") +
   ylab("AdWord Clicks") +
   ggtitle("Total AdWords Clicks per Week")
plot(myplot)
dev.off()

# Plot AdWords cost per week as a bar plot
pdf("AdWords_weekly_cost_bar.pdf", width=7, height=7)
myplot <- ggplot(data = adwords_sum_by_week, mapping = aes(x = week, y = cost)) +
   geom_col() +
   xlab("Week from Jul 3, 2017 - Nov 12, 2017") +
   ylab("AdWord Cost") +
   ggtitle("Total AdWords Cost per Week")
plot(myplot)
dev.off()

# Plot AdWords cost per week as a dot plot
pdf("AdWords_weekly_cost_line.pdf", width=7, height=7)
myplot <- ggplot(data = adwords_sum_by_week, mapping = aes(x = week, y = cost)) +
  geom_line() +
   geom_point() +
   xlab("Week from Jul 3, 2017 - Nov 12, 2017") +
   ylab("AdWord Cost") +
   ggtitle("Total AdWords Cost per Week")
plot(myplot)
dev.off()

# Need to aggregate sales by week too
print("--------------------- Sales before changes")
glimpse(sales)

# Cast purchase_date as YMD
# <chr> "2017-10-01T06:57:00"
sales$ymd_date <- sales$purchase_date %>% str_sub( 1, 10) %>% ymd()

# Create a week column
sales$week <- lubridate::isoweek(sales$ymd_date)

# Trim off the partial weeks from start and end
sales <- filter(sales, week != "26", week != "46")

print("-------------------- Sales after adding ymd_date and week columns")
glimpse(sales)

print("---------------------- Sales grouped-by Week")
sales_by_week <- sales %>% group_by(week)
sales_sum_by_week <- sales_by_week %>% summarize(
    item_price = sum(item_price)
    )
# I want a "date" field back so that I can use it as an axis label in my plot
sales_sum_by_week$date <- as.Date(paste(2017, sales_sum_by_week$week, 1, sep="-"), "%Y-%U-%u")
glimpse(sales_sum_by_week)
print("------")

print("---------------------- Sales grouped-by Day")
sales_by_day <- sales %>% group_by(ymd_date)
sales_sum_by_day <- sales_by_day %>% summarize(
    item_price = sum(item_price)
    )
glimpse(sales_sum_by_day)
print("------")

# Plot Sales revenue per day as a dot plot
pdf("sales_daily_revenue.pdf", width=7, height=7)
myplot <- ggplot(data = sales_sum_by_day, mapping = aes(x = ymd_date, y = item_price)) +
   geom_point() +
   geom_smooth(method = "lm", se = FALSE) +
   xlab("Date") +
   ylab("Sales") +
   ggtitle("Daily Sales")
plot(myplot)
dev.off()

# Plot Sales revenue per week as a dot plot
pdf("sales_weekly_revenue_line.pdf", width=7, height=7)
myplot <- ggplot(data = sales_sum_by_week, mapping = aes(x = date, y = item_price)) +
   geom_point() +
   geom_line() +
   xlab("Date") +
   ylab("Sales") +
   ggtitle("Weekly Sales")
plot(myplot)
dev.off()

# Sales grouped by product_name
print("---------------------- Sales grouped-by Day and Product")
sales_by_product <- sales %>% group_by(product_name)
sales_sum_by_product <- sales_by_product %>% summarize(
    item_price = sum(item_price)
    )
glimpse(sales_sum_by_product)
print("------")

# Plot Total Sales by Product
pdf("sales_by_product_bar.pdf", width=7, height=7)
myplot <- sales_sum_by_product %>% ggplot(mapping = aes(x = reorder(product_name, item_price), y = item_price)) +
   geom_col() +
   xlab("Product Name") +
   ylab("Total Sales") +
   coord_flip() +
   ggtitle("Total Sales by Product")
plot(myplot)
dev.off()

sales_sum_by_product
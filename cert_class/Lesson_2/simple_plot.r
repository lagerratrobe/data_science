# Connect to Kitty-litter and adwords data sets in SQLite and generate some plots

library(tidyverse)
library(stringr)
library(DBI)
library(RSQLite)
library(lubridate)


df <- read_csv('mpg.csv')
#glimpse(df)

# Plot an easy one, AdWords clicks per day
pdf("simple_plot.pdf", width=7, height=7)

myplot <- ggplot(data = df)  +
   geom_dotplot(mapping = aes(x = hwy))
   #geom_smooth(method = "lm", se = FALSE) +
   #ggtitle("Total AdWords Clicks per Day")
   
plot(myplot)
dev.off()

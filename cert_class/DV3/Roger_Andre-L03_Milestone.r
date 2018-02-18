# Roger_Andre-L03_Milestone.r

library(data.table)
library(tidyverse)

# Load the two CSV files in R using "fread" function from data.table package.
#Name them MFG_DEFECT_DATA and RETURNS_DATA.
MFG_DEFECT_DATA <- fread('MFG_DEFECT_DATA.csv')
RETURNS_DATA <- fread('RETURNS_DATA.csv')

# Convert dataframes to data.table
MFG_DEFECT_DATA <- as.data.table(MFG_DEFECT_DATA)
RETURNS_DATA <- as.data.table(RETURNS_DATA)

# add a new column to MFG_DEFECT_DATA called MFG_DEFECT_RATE where MFG_DEFECT_RATE = ITEMS_DEFECTIVE/ITEMS_SAMPLED
MFG_DEFECT_DATA[, MFG_DEFECT_RATE := ITEMS_DEFECTIVE/ITEMS_SAMPLED, ]

# MFG_DATE column is currently in character format. Convert it to a Date format in both data sets.
MFG_DEFECT_DATA$MFG_DATE <- as.Date(MFG_DEFECT_DATA$MFG_DATE, "%m/%d/%y")
RETURNS_DATA$MFG_DATE <- as.Date(RETURNS_DATA$MFG_DATE, "%m/%d/%y")

# Export data into CSV format
write.csv(MFG_DEFECT_DATA, "new_MFG_DEFECT_DATA.csv", row.names = FALSE)
write.csv(RETURNS_DATA, "new_RETURNS_DATA.csv", row.names = FALSE)

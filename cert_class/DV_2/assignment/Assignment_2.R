#install.packages("data.table")
#install.packages("sqldf")
#install.packages("tidyverse")

library(sqldf)
library(tidyverse)
require(data.table)

# Load the 3 CSV files in R using the fread function from data.table package.
address <- fread("Address.csv")
business_entity_address <- fread("BusinessEntityAddress.csv")
employee <- fread("Employee.csv")

# Assume the 3 files are database tables and write a SQL query to join all the tables together
# and filters the data for Job Titles that start with the word 'Research' 
sql_query <- ("SELECT b.BusinessEntityID, e.LoginID, e.JobTitle, a.City 
              FROM business_entity_address b 
              INNER JOIN employee e 
              ON b.BusinessEntityID = e.BusinessEntityID 
              INNER JOIN address a 
              ON b.AddressID = a.AddressID 
              WHERE e.JobTitle like 'Research%';")

# Use the sqldf package to run the sql from the step above.
results <- sqldf(sql_query)

results

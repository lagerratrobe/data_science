#install.packages("RODBC")
#install.packages("data.table")
#install.packages("sqldf")
#install.packages("tidyverse")

require("RODBC")

# Create connection string
con = odbcConnect("AdventureWorks") # This is reading the ODBC System DSN

sqlTables(con)$TABLE_NAME  # Gets a list of tables from the DB

# Execute query and store results in hr_emp
hr_emp = sqlQuery(con, "SELECT * FROM HumanResources_Employee")

colnames(hr_emp)
write.csv(hr_emp, "hr_emp_f.csv", row.names = FALSE)

library(sqldf)
library(tidyverse)

# Using: HumanResources_Employee, HumanResources_EmployeeAddress & Person_Address
# create a table that contains EmployeeID and City

employee <- sqlQuery(con, "SELECT * FROM HumanResources_Employee")
glimpse(employee)

employee_address = sqlQuery(con, "SELECT * FROM HumanResources_EmployeeAddress")
glimpse(employee_address)

person_address = sqlQuery(con, "SELECT * FROM Person_Address")
glimpse(person_address)

sql = "SELECT e.EmployeeID, pa.City FROM employee e INNER JOIN employee_address ea ON e.EmployeeID = ea.EmployeeID INNER JOIN person_address pa 
ON ea.AddressID = pa.AddressID;"

foo = sqldf(sql)

glimpse(foo)

foo %>% head(10)

hr_emp = as.data.table(hr_emp)

# USE data.table to make a SQL query, "All EmployeeID with VacationHours > 20
hr_emp[VacationHours > 20 & Title %like% 'Technician', c("EmployeeID", "LoginID", "VacationHours", "Title")]

as.Date("03-15-2017", "%m-%d-%Y")

dates = fread("date.csv")
dates

dt = as.data.table(dates)

# Show Total_Sales for Jan 20, 2017
dt[ Sale_Date == as.Date('2017-01-20', "%Y-%m-%d"), c(Total_Sales)]
dt[ Sale_Date == as.Date('2017-01-20', "%Y-%m-%d"), ,]

# Show Total_Sales for entire Month of Jan 2017
dt[ month(Sale_Date) == 1 & year(Sale_Date) == 2017, .( Monthly_Sales = sum(Total_Sales) ), ]

library(lubridate)
help(ymd)
dates$Sale_Date <- ymd(dates$Sale_Date)
glimpse(dates)
dt = as.data.table(dates)
glimpse(dt)

# sum(Total_Sales) GROUP BY month(Sale_Date)
dt[ year(Sale_Date) == 2016, .(Monthly_Sales = sum(Total_Sales)), by = month(Sale_Date) ]

dt[ year(Sale_Date) == 2016, .( Monthly_Sales = sum(Total_Sales) ), ]

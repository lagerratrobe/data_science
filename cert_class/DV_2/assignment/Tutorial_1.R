#install.packages("RODBC")
#install.packages("data.table")
#install.packages("sqldf")
install.packages("tidyverse")

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

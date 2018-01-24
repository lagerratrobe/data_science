install.packages("RODBC") #install the RODBC pkg
install.packages("data.table") #install the data.table pkg
install.packages("sqldf") #install the sqldf pkg

# Install the AdventureWorks database.
# "AdventureWorks.accdb"

#####################################################################
# Using RODBC to connect to a database
#####################################################################
require("RODBC")
# Create a connection 

# Using a DSN: If you have already created a DSN for AdventureWorks, 
# then you could do the following. If you have not created a DSN yet
# please follow the instructions in the course and then continue..
con = odbcConnect("AdventureWorks")

#Get a list of tables from the database using the connection "con"
sqlTables(con)$TABLE_NAME

sql_string = "Select * from HumanResources_Employee"
hr_emp = sqlQuery(con, sql_string)
head(hr_emp)

#Column names of table hr_emp
colnames(hr_emp)

#Writing this hr_emp dataset to a csv file for later user
write.csv(hr_emp, "hr_emp.csv", row.names = FALSE)

#####################################################################
# Using RODBC to execute queries from a data base
#####################################################################
# Question: Using tables HumanResources_Employee, 
# HumanResources_EmployeeAddress and Person_Address, 
# create a table that contains EmployeeID and City

# Let's first explore the three tables
head(sqlQuery(con, "Select * from HumanResources_Employee"))

head(sqlQuery(con, "Select * from HumanResources_EmployeeAddress"))

head(sqlQuery(con, "Select * from Person_Address"))

# Here is how the query looks
# notice the quotes before and after the sql string
sql_str = "Select t1.EmployeeID, 
t2.AddressID, 
t3.City 
FROM HumanResources_Employee t1 
LEFT OUTER JOIN HumanResources_EmployeeAddress t2 
ON t1.EmployeeID = t2.EmployeeID 
LEFT OUTER JOIN Person_Address t3 
ON t3.AddressID = t2.AddressID"

# this will show the output of the sql query that we wrote above
head(sqlQuery(con, sql_str))


#####################################################################
# Reading CSV files in R - multiple methods
#####################################################################

#syntax: read.delim(file = "filepath", sep = "usually , or \t", dec = "decimal point as . or ," )
hr_emp = read.delim(file = "~/Documents/RProjects/DataViz/hr_emp.csv", sep = ",", dec = "." )
head(hr_emp)

#syntax: read.csv(file = "filepath", header = TRUE, sep = "usually , or \t", dec = "decimal point as . or ,")
hr_emp = read.csv(file = "~/Documents/RProjects/DataViz/hr_emp.csv", sep = ",", dec = ".")
print(hr_emp)

require(data.table)
#syntax: fread(input = "filepath", header = TRUE, sep = "usually , or \t")
hr_emp = fread(input = "~/Documents/RProjects/DataViz/hr_emp.csv", header = TRUE, sep = ",")
print(hr_emp)

#####################################################################
# Using sqldf to run SQL on R data frames or data tables
#####################################################################
require(sqldf)
# Question 1: From the hr_emp dataset, find the EmployeeIDs 
# and LoginIDs of those employees who have over 20 hrs of Vacation
dt = sqldf("Select EmployeeID, LoginID from hr_emp where VacationHours>20")
class(dt)

# Question 2: From the hr_emp dataset, find the EmployeeIDs of those employees 
# who have over 20 hrs of Vacation
# ...AND have the word "Technician" in their Title
sql_statement = "Select EmployeeID, 
LoginID 
from hr_emp 
where VacationHours>20 AND Title like '%Technician%'"
sqldf(sql_statement)


#####################################################################
# Using data.table to manipulate data
#####################################################################
# Syntax: data_table_name[ where_conditions, columns_to_select, extra_parameters]

# Question 1: From the hr_emp dataset, find the EmployeeIDs and LoginIDs of those employees 
# who have over 20 hrs of Vacation
# The SQL statement was: ("Select EmployeeID, LoginID from hr_emp where VacationHours>20")
# In data.table, the data_table_name = hr_emp; where_conditions = VacationHours>20

#First, lets convert the data.frame hr_emp to data.table format
class(hr_emp)
hr_emp = as.data.table(hr_emp)

# Now lets rewrite the same SQL statement in R data.table syntax:
hr_emp[VacationHours>20, c("EmployeeID", "LoginID"), ]


# In this example we will replace all the NA values in the hr_emp table with a certain value 999
head(hr_emp)
hr_emp[is.na(hr_emp)]=999

# Notice the rowguid column - All the NAs have been converted to 999
print(hr_emp)

# Now lets convert all the 999s back to NA
hr_emp[hr_emp==999]=NA
print(hr_emp)

hr_emp[is.null(hr_emp)]=999 #where is.na is replaced by is.null.

# In this example, we will take the hr_emp table and group employees who have more than 10 hours of 
# VacationHours into a group called Eligible. We could do this two ways. The bad way to do this 
# will be to overwrite the values in the VacationHours column with a Yes/No flag. 
# The good way to do this will be to create a new column, say, Benefits_Eligible. This column 
# could have values of Yes or No depending on the value of the VacationHours column. 
#Let's see how to do this using data.table package
# Syntax dataset[conditions, new_column := "your value", ]
# Those with VacationHours>10 are Benefits eligible
hr_emp[VacationHours>10,  Benefits_Eligible := "Yes", ]

# Those with VacationHours<=10 are Benefits ineligible
hr_emp[VacationHours<=10, Benefits_Eligible := "No",  ]

# Pay attention to the new column "Benefits_Eligible" that is created at the end of the dataset
print(hr_emp)

# Consider the following example: In the hr_emp table, convert the EmployeeID to factor 
# and then back to integer
hr_emp[, EmployeeID := as.factor(EmployeeID), ]

# Notice that the variable class of EmployeeID column has now changed to factor with 3 levels
class(hr_emp$EmployeeID)
hr_emp$EmployeeID

# Now, lets change the EmployeeID columbn back to integer type
hr_emp[, EmployeeID := as.integer(EmployeeID), ]
# Notice that the variable class of EmployeeID column has now changed to integer with 3 values
class(hr_emp$EmployeeID)

# Similarly, you will frequently use the following transformations: 
# 1. as.numeric() works for integers and decimals 
# 2. as.character() 
# 3. as.Date See example:   or  as.Date("03-15-2017", format = "%m-%d-%Y")

as.Date("02/22/17", format = "%m/%d/%y")
as.Date("02-22-17", format = "%m-%d-%y")

as.Date("03-15-2017", format = "%m-%d-%y") # WRONG
as.Date("03-15-2017", format = "%m-%d-%Y") # Correct

my_date = as.Date("03-15-2017", format = "%m-%d-%Y")

# Some more date related functions
month(my_date)
year(my_date)








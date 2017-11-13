library(odbc)
library(DBI)
library(tidyverse)
#driver_name <- "ODBC Driver 13 for SQL Server"
driver_name <- "/usr/local/anaconda2/lib/libmsodbcsql-11.0.so.2270.0"
server_name <- "uwc-sqlserver.clients.uw.edu"
database_name <- "AdventureWorks2016CTP3"
user_id <- "sqlstudentreader"
password <- "PA6aX2gAhe4hE!ru$6atru"
conn <- dbConnect(odbc::odbc(), driver = driver_name,server = server_name,database = database_name,uid = user_id,pwd = password)

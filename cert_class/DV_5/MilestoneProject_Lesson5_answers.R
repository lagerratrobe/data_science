
#Load the data into your notebook. Make sure you have the .csv file in your working directory!


read.auto = function(file = 'imports-85.csv'){
  
  auto.price <- read.csv(file, header = TRUE, 
                         stringsAsFactors = FALSE)
  

  numcols <- c('price', 'bore', 'stroke', 'horsepower', 'peak.rpm')
  auto.price[, numcols] <- lapply(auto.price[, numcols], as.numeric)
 
  auto.price[complete.cases(auto.price), ]
}
auto.price = read.auto()

str(auto.price)
auto.sub = auto.price[, c('wheel.base', 'curb.weight', 'engine.size', 'horsepower', 'city.mpg', 'price')]
summary(auto.sub)

lapply(auto.sub, sd)

head(auto.price, n =10)
tail(auto.price)
table(auto.price$make)
table(auto.price$make, auto.price$fuel.type)


require(ggplot2)
ggplot(auto.price, aes(body.style)) + ## Specify the data frame and columns. Note the + chain operator
  geom_bar()  ## Fuction for the plot type

#ANSWER: QUESTION 1 = SEDAN
#ANSWER: QUESTION 2 = CONVERTIBLE

#ANSWER: QUESTION 3
ggplot(auto.price, aes(x=reorder(num.of.doors,num.of.doors, function(x) -length(x)))) + ## Function shorts the bars
  geom_bar() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) 

#ANSWER: QUESTION 4
ggplot(auto.price, aes(price)) + geom_histogram() + 
  ggtitle('Histogram of auto price')

#ANSWER: QUESTION 5
ggplot(auto.price, aes(x = factor(fuel.type), y = price)) + geom_boxplot() + 
  xlab('Fuel type') + ggtitle('Price by Fuel Type')

#ANSWER: QUESTION 6
ggplot(auto.price, aes(x = factor(body.style), y = price)) + geom_boxplot() + 
  xlab('Body Style') + ggtitle('Price by Body Style')

#ANSWER: QUESTION 7 = HATCHBACK
# ANSWER: QUESTION 8: SEDAN AND WAGON AND/OR CONVERTIBLE AND HARDTOP

#ANSWER: QUESTION 9:
ggplot(auto.price, aes(price)) + geom_density()

#ANSWER: QUESTION 10: GRAPH IS SKEWED THE LEFT OR LOW SIDE. iT SHOWS SIMILAR TREND AS A HISTOGRAM FOR PRICE

#ANSWER: QUESTION 11:
ggplot(auto.price, aes(x = factor(body.style), y = price)) + 
  geom_violin(trim = TRUE, draw_quantiles = c(0.25, 0.5, 0.75))

#ANSWER: QUESTION 12: PRICE OF HATCHBACKS IS HEAVILY CONCENTRATED AROUND MEDIAN WHILE THOSE OF HARDTOP ARE AWAY FROM MEDIAN PRICE

#ANSWER: QUESTION 13: 
ggplot(auto.price, aes(x = city.mpg, y = horsepower)) + geom_point() + 
  xlab('City MPG') + ylab('Horsepower') + 
  ggtitle('Relationship between City MPG and Horsepower')

#ANSWER: QUESTION 14: STRONG RELATIONSHIP WITH MANY REGIONS SHOWING CLOSE TO EACH OTHER

#ANSWER: QUESTION 15: RELATIONHSIP BEWTWEEN CITY MPG AND PRICE HAS MULTIPLE CLUSTERS OF CONCENTRATION. THE OUTLIERS ARE MORE PROMINENT IN ALL GROUPS

#ANSWER: QUESTION 16: AT 30 MPG, THERE ARE A LARGE NUMBER OF AUTOS AT LOW PRICE
#ANSWER: QUESTION 17: OUTLIERS ARE SEEN AT THE FAR RIGHT OF THE GRAPH AT 50 MPG AND ALSO TO THE TOP LEFT AT THE HIGHEST PRICE 

# ANSWER: QUESTION 18:

ggplot(auto.price, aes(city.mpg, horsepower)) + 
  stat_binhex(bins = 10) +
  xlab('City MPG') + ylab('horsepower') +
  ggtitle('Relationship between City MPG and Horsepower')

#ANSWER: QUESTION 19: 
# IN PLOT #1: THERE ARE 2 BLOBS OF DATA CLUSTERS BUT NOT MUCH CLARITY TO DRAW ANY FIRM CONCLUSIONS. REASON MIGHT BE OVERPLOTTING
# IN PLOT #2 : THE HEAT MAP OR RASTOR PLOT SHOWS THE 2 SETS OF CLUSTERS CLEARLY FOR WAITING TIME

#ANSWER: QUESTION 20: STUDENTS TO SUBMIT WORD DOC SEPARATELY
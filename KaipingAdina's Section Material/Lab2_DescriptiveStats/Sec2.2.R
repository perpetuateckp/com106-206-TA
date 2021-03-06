# Research Question: Does Racial Discrimination exist in the labor market?
#### Section 2.2: Subsetting the Data in R
## First import the resume file (note: please set up your working directory ot the place where you have the dataset)
resume <- read.csv("resume.csv")
## Quickly look at your data
head(resume)
dim(resume)

##What is the callback rate?  Need to look just at the column "call" and find out how many that have 
## Learn these: == , !=, >, <, >=, <=, &, | 
## Note, when subsetting a single vector, you don't need a comma in the brackets [ ]
## When subsetting a data frame, you need the comma to tell R which row and column you are subsetting

##Access one column (variable) in a data set
resume$call

# Obatin the callback info for respondents whose race == black. We need to subset the column!
levels(resume$race)
resume$call[resume$race == "black"]

##Let us compare the mean (average) call rate for the black group and the white group
mean_black_call = mean(resume$call[resume$race == "black"]) ## Note the parentheses. Function works on everything inside parentheses is 
mean_black_call
mean_white_call = mean(resume$call[resume$race == "white"])
mean_white_call

## More to look at subsets: race of first 5 observations (rows)
resume$race[c(1, 2, 3, 4, 5)]
resume$race[1:5]  

## Create a new data frame, with only race == black (note the comma in the brackets)
resumeB <- resume[resume$race == "black", ] 
dim(resumeB) # this data.frame has fewer rows than the original data.frame
head(resumeB)
mean(resumeB$call) # callback rate for race == black

##More on Create new datasets with subset function.

## keep "call" and "firstname" variables 
## also keep observations with race==black and sex==female
# note: select = c() is for you to select what variables you want to have for the new dataset, subset = is for you to give the criteria for subsetting
resumeBf <- subset(resume, select = c("call", "firstname"),
                   subset = (race == "black" & sex == "female"))
head(resumeBf)

### Section 2.2.4: Simple Conditional Statements: IFELSE Function

#create a new variable that makes a black female 1 and everyone else 0
resume$BlackFemale <- ifelse(resume$race == "black" & 
                               resume$sex == "female", 1, 0)

### Section 2.2.5: Factor Variables - important for any categorical variable (nominal)
#create a new variable type to categorize based on race and sex
resume$type[resume$race == "black" & resume$sex == "female"] <- "BlackFemale"
resume$type[resume$race == "black" & resume$sex == "male"] <- "BlackMale"
resume$type[resume$race == "white" & resume$sex == "female"] <- "WhiteFemale"
resume$type[resume$race == "white" & resume$sex == "male"] <- "WhiteMale"

## coerce new character variable into a factor variable
# note: you must as.factor the variable type in order to tell computers that it is nominal
class(resume$type) # the type variable is character.
resume$type <- as.factor(resume$type)
## list all levels of a factor variable
levels(resume$type)

## obtain the number of observations for each level (two very important functions)
table(resume$type) # raw frequency count
prop.table(table(resume$type)) # proportion
table(type = resume$type, call = resume$call) ##table by category

# cross-tab: how many people under each type are called (and not called)?
# remember that IV is on the column and DV is on the row
table_type_call = table(call =resume$call, type = resume$type) ## Write the row variable first, then column variable
table_type_call
prop.table(table_type_call) ## this will provide percentage of each cell as part of the total population
prop.table(table_type_call, 1) # the "1" included in prop.table will tell R to make the rows add up to 100%
# note: the code line below responds to the lecture that the percentages in each column should sum up to 1
prop.table(table_type_call, 2) # the "2" included in prop.table will tell R to make columns add up to 100%
##You can also write the above code line like this:
prop.table(table(call = resume$call, type = resume$type), 2) ## note prop.table function is for a table.


# compare the mean call rate for each type (compare DV under different levels of an IV)
tapply(resume$call, resume$type, mean)

## More exercise on table and tapply.
## turn first name into a factor variable 
resume$firstname <- as.factor(resume$firstname)
## compute the callback rate for each first name
callback.name <- tapply(resume$call, resume$firstname, mean)
## sort the result in the increasing order
sort(callback.name)

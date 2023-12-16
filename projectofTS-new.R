# Step is to load necessary libraries
library(tsibble)
library(lubridate)
library(fpp3)
library(dplyr)
library(ggplot2)
library(scales)
library(fable)
library(fabletools)


##################### Start of the Preparing #####################
# Read the data
Data <- read.csv("C:\\Users\\sarah\\Downloads\\owid-covid-data.csv")

Data <- Data %>%
  filter(continent == "South America") %>%
  select(continent, new_cases, date) %>%
  group_by(continent, date) %>%
  summarise(total_new_cases = sum(new_cases))
Data

# Check if there is missing values for Data
missing_values <- sum(is.na(Data))

if (missing_values > 0) {
  print(paste("The dataset contains", missing_values, "missing value(s)."))
} else {
  print("The dataset does not have any missing values.")
}

# If need to remove rows with missing values
Data <- na.omit(Data)

# update a date column format from char to date as day format to can be used in Time Series tsibble
Data <- Data %>%
  mutate( date = as_date(date))

# Create a tsibble 
Data_tsibble <- as_tsibble(Data, key = continent, index = date)

# View the tsibble
Data_tsibble


##################### End of the Preparing #####################

##################### Start of the Preparing for Datawithlocation #####################
# Read the data
Datawithlocation <- read.csv("C:\\Users\\sarah\\Downloads\\owid-covid-data.csv")

Datawithlocation <- Datawithlocation %>%
  filter(continent == "South America") %>%
  select(continent, new_cases, date,location) %>%
  group_by(continent, date,location) %>%
  summarise(total_new_cases = sum(new_cases))
Datawithlocation

# update a date column format from char to date as day format to can be used in Time Series tsibble
Datawithlocation <- Datawithlocation %>%
  mutate( date = as_date(date))

# Check for missing values
missing_values <- sum(is.na(Datawithlocation))

# Print the result
if (missing_values > 0) {
  print(paste("The dataset contains", missing_values, "missing value(s)."))
} else {
  print("The dataset does not have any missing values.")
}

# Remove rows with missing values
Datawithlocation <- na.omit(Datawithlocation)

# Create a tsibble with a location
tsibblewithlocation <- as_tsibble(Datawithlocation, key = c(continent,location), index = date)

# View the tsibble
tsibblewithlocation

##################### End of the Preparing for Datawithlocation #####################

##################### Start of the Visualization #####################

# autocorrelation
Data_tsibble %>% gg_lag(total_new_cases, geom = "point")

# fill gaps for ACF plot
Data_tsibble <- fill_gaps(Data_tsibble)

# Plot the ACF
Data_tsibble |> ACF(total_new_cases, lag_max = 9) |> autoplot()

# Plot the ACF
Data_tsibble |> ACF(total_new_cases, lag_max = 50) |> autoplot()

#season plot weekly 
Data_tsibble |>
  gg_season(total_new_cases ,period = "week")

#time plot using ggplot
Data_tsibble |>
  ggplot(aes(x=date , y=total_new_cases))+
  geom_line()

#time plot using autoplot
Data_tsibble |>
  autoplot(total_new_cases)

## sub series 
Data_tsibble |>
  gg_subseries(total_new_cases ,period = "week")

####this the way of mathematical transformation####

#using log
Data_tsibble |> autoplot(log(total_new_cases)) 

#using log square root
Data_tsibble |> autoplot(sqrt(total_new_cases)) 

#using cube root 
Data_tsibble |> autoplot(total_new_cases^(1/3))

#using inverse
Data_tsibble |> autoplot(-1 / total_new_cases)

#to fine the best value of lambda
Data_tsibble |> features(total_new_cases, feature = guerrero)

#this is the plot with the best value of lambda
Data_tsibble |> autoplot(box_cox(total_new_cases,  0.587))

#this is the time plot to compare
Data_tsibble |> autoplot(total_new_cases)


##################### End of the Visualization #####################


##################### Start of the Visualization with Datawithlocation#####################
#gg plot with location (points)
tsibblewithlocation |>
  ggplot(aes(x=date , y=total_new_cases  , colour= location))+
  geom_point() 

#gg plot with location (lines)
tsibblewithlocation |>
  ggplot(aes(x=date , y=total_new_cases  , colour= location))+
  geom_line() 

# fill gaps 
tsibblewithlocation<- fill_gaps(tsibblewithlocation)

#gg seasonal
tsibblewithlocation |>
  gg_season(total_new_cases) +
  facet_wrap(vars(location), nrow = 7, scales = "free_y" )

## sub series with location
tsibblewithlocation |>
  gg_subseries(total_new_cases  ,period = "week")
##################### End of the Visualization with Datawithlocation #####################

### Start Specifying Model, Model Estimation,Performance Evaluation##########


# Splitting the data
split_point <- floor(nrow(Data_tsibble) * 0.8) # 80% for training
train_data <- head(Data_tsibble, split_point)
test_data <- tail(Data_tsibble, -split_point)


# Training the naive model
naive_model <- train_data %>%
  model(naive = NAIVE(total_new_cases))

# Training the snaive model
snaive_model <- train_data %>%
  model(snaive = SNAIVE(total_new_cases))

# Training the regression model
regression_model <- train_data %>%
  model(regression = ARIMA(total_new_cases ~ 1))

# Training the TSLM model
tslm_model <- train_data %>%
  model(tslm = TSLM(total_new_cases))

# Generating forecasts with the naive model
naive_forecast <- naive_model %>%
  forecast(new_data = test_data)

# Generating forecasts with the snaive model
snaive_forecast <- snaive_model %>%
  forecast(new_data = test_data)


# Generating forecasts with the regression model
regression_forecast <- regression_model %>%
  forecast(new_data = test_data)

# Generating forecasts with the TSLM model
tslm_forecast <- tslm_model %>%
  forecast(new_data = test_data)

# Evaluating the models
naive_accuracy <- accuracy(naive_forecast, test_data)
snaive_accuracy <- accuracy(snaive_forecast, test_data)
regression_accuracy <- accuracy(regression_forecast, test_data)
tslm_accuracy <- accuracy(tslm_forecast, test_data)

# Printing the accuracies
print(naive_accuracy)
print(snaive_accuracy)
print(regression_accuracy)
print(tslm_accuracy)

# forecast plots:
library(ggfortify)
naive_forecast |> autoplot(Data_tsibble) + 
  labs(title=" naive forecast")‍
‍
snaive_forecast |> autoplot(Data_tsibble) + 
  labs(title=" seasonal naive forecast")‍
‍
regression_forecast |> autoplot(Data_tsibble) + 
  labs(title=" regression model forecast")‍
‍
tslm_forecast |> autoplot(Data_tsibble) + 
  labs(title=" TSLM model forecast")









# Time-series-project

The project titled "Analysis and Forecasting of COVID-19 New Cases in South America. The project aimed to prepare and analyze COVID-19 data for South America, with a focus on forecasting new cases.

Preparing Data: 
The objective of this phase was to transform the raw COVID-19 data for South America into a structured and clean dataset suitable for analysis. Missing values were addressed, relevant columns were selected, and the data was summarized. Two datasets were created: "Data" at the continent level and "Datawithlocation" with location-specific information. The data was converted into tsibble objects for time series analysis.

Data Visualization: 
Various visualization techniques were employed to explore the data. Lag plots were used to identify seasonality, autocorrelation function (acf) plots were utilized to analyze correlations, and seasonal plots were created to detect seasonality, trends, and cyclic patterns. Mathematical transformations such as logarithmic, square root, cube root, and inverse were applied to enhance visualization.

Specifying Model:
Seasonal Naive (Snaive) Model:
The "Seasonal Naive" or "Snaive" method is a simple and straightforward time series 
forecasting technique used for data that exhibits strong seasonality. This method involves 
making forecasts based on the most recent observed value from the same season in the previous 
year. 
Justification: The model is chosen based on the robust seasonal patterns evident in the data, 
reflected in the significant positive correlation between seasons. It operates on the premise that 
forthcoming values will closely mirror the most recent observation within the same season, 
adeptly encapsulating recurring patterns. This choice is particularly suitable for the COVID-19 dataset, which exhibits pronounced seasonality.

Naive Method:
The "Naive Method" is one of the simplest and most straightforward time series forecasting 
techniques. It involves making forecasts based solely on the most recent observation in the 
time series. The Naive Method assumes that future values will be the same as the most recent 
observed value.
Justification: The Naive Method can serve as a straightforward benchmark and provide a 
quick reference point for assessing the performance of more complex models. While it does 
not consider seasonality, trends, or external factors, it can be useful in situations where the data 
is relatively stable over time or when you need a basic, rapid forecast to gain a preliminary 
understanding of future trends.

Regression model:
A regression model is a statistical approach used to examine and quantify the relationship 
between a dependent variable and one or more independent variables. It aims to model the 
dependency between these variables and make predictions or estimate the value of the 
dependent variable based on the values of the independent variables.
Overall, the project aimed to provide insights into the COVID-19 new cases in South America by analyzing historical data and forecasting future trends. The team members collaborated on various tasks, including data preparation, visualization, and modeling, to achieve the project objectives.
Justification: A regression model can be a suitable choice for forecasting COVID-19 data, 
considering the evident trends and seasonality patterns observed in the provided information. 
The scatterplots (Figure 5) reveal strong positive correlations between daily total new cases, 
highlighting significant seasonality. Figures 6 and 7 display autocorrelation functions, 
indicating the presence of strong positive correlations, confirming non-white noise 
characteristics in the data. The presence of lagged variables further supports the temporal 
dependencies. Furthermore, the weekly and yearly plots depict distinct patterns, such as the 
highest new cases on Fridays and fluctuations over time. By incorporating these features and 
patterns as explanatory variables, a regression model can effectively capture and forecast the 
complex dynamics of COVID-19 data.

TSLM (Time Series Linear Model): 
A Time Series Linear Model (TSLM) is a statistical modeling approach used to analyze and 
forecast time series data, which is a sequence of data points collected at successive, equally 
spaced time intervals. TSLM is a linear regression model designed to capture and describe the 
underlying linear relationships within time series data. It is a straightforward method that 
assumes that the time series data can be represented as a linear combination of its past values.
Justification: The model is a flexible approach that can accommodate various components of 
COVID-19 data, including seasonality, trends, and external factors. The Time Series Linear 
Model (TSLM) effectively extends the concept of simple linear regression within the domain 
of time series, enabling the inclusion of both time-dependent and non-time-dependent 
covariates within the model. This makes TSLM an appropriate choice when distinct patterns 
of seasonality and cyclic behavior have been identified in the data, and when there is an 
anticipation of the impact of external variables on COVID-19 cases.


Model Estimation:
To forecast the future cases of COVID-19 in South America, we employed several models and 
followed a structured process:

Data Splitting:
The first step in our forecasting process was to split the data into training and test sets. 
This data division is crucial for time series forecasting.
We calculated the split_point to represent 80% of the total number of rows in the Data_tsibble. 
This division ensured that 80% of the data was allocated to the training set, while the remaining 
20% was reserved for testing the model's performance.

Model Training:
We then proceeded to train four different models:
Naive Model: This model, trained using the NAIVE function, assumed that the future value of 
the total new cases of COVID-19 is equal to the most recent observed value.
Seasonal Naive Model: The SNAIVE function was used to train this model, which takes into 
account the seasonality of the data. It predicts future values based on the corresponding values 
from the same season in previous years.
Regression Model: In this model, we employed a regression model with a constant term 
(total_new_cases ~ 1). This model captured both the trend and seasonality of the data.
Time Series Linear Model (TSLM): The TSLM function was utilized to train this model, which 
considered the linear relationship between the total new cases of COVID-19 and time. It could 
capture trend, seasonality, and other time-dependent patterns.

Generating Forecasts:
After training the models, we generated forecasts using the test data for evaluation purposes. 
These forecasts were stored in separate variables (naive_forecast, snaive_forecast, 
regression_forecast, tslm_forecast) for further analysis and comparison.
This comprehensive approach allowed us to assess the performance of multiple forecasting 
models and select the most suitable one for predicting future COVID-19 cases in South 
America.

Performance Evaluation:
Selecting the optimal model necessitates careful consideration of the specific needs of the 
application and which performance metrics are of utmost importance. The assessment involves 
four key metrics: ME (Mean Error), RMSE (Root Mean Square Error), MAE (Mean Absolute 
Error), and ACF1 (Auto-Correlation Function at lag 1).

▪ ME: A lower absolute ME is preferable, indicating less systematic bias. The Snaive 
model has the smallest absolute ME, suggesting more unbiased forecasts.
▪ RMSE: A lower RMSE indicates better performance. The TSLM model leads in this 
category with the lowest RMSE, suggesting it handles large errors more effectively.
▪ MAE: A lower MAE indicates superior performance. Here, the Snaive model reports 
the lowest MAE, highlighting its effectiveness in minimizing average errors.
▪ ACF1: A lower absolute value of ACF1 is desirable, implying less autocorrelation in 
prediction errors. The Snaive model scores the lowest ACF1.
Justification for Model Performance:
▪ Snaive Model: Despite the pronounced seasonality in COVID-19 data, the Snaive 
model was not the overall best performer. Although it has the lowest MAE and ACF1, 
indicating effectiveness in minimizing average errors and error autocorrelation, its 
higher RMSE compared to the TSLM model suggests limitations in handling complex 
interdependencies and larger errors.
▪ Naive Method: Useful as a benchmark for stable data or initial trend analysis but lacks 
sophistication for the complexities of COVID-19 data.
▪ Regression Model: Suitable for capturing trends and seasonality but may not fully 
encapsulate COVID-19 data dynamics as effectively as the TSLM model.
▪ TSLM (Time Series Linear Model): Used to fit a linear model including trend and 
seasonal components. Therefore, it emerges as the top contender with the lowest RMSE, indicating its superior capability in capturing both the linear trends and the 
complex dynamics of COVID-19 data, including seasonality and other factors.
In summary, for overall predictive precision and handling of larger errors, the TSLM model is 
recommended, particularly for COVID-19 data exhibiting complex patterns of seasonality and 
cyclic behavior. However, if the primary focus is on reducing systematic bias or minimizing 
average error autocorrelation, the Snaive model's performance in these areas makes it a strong 
contender.

Producing Forecast:
In the final step of our analysis, we generated forecasting plots for each of the models to assess 
their performance in relation to the actual data.



IMPORT Data_Modules.Taxi_Weather;
IMPORT ML_Core.Analysis;
IMPORT Utils;


#WORKUNIT('NAME', '5_LogisticRegression');

//Logistic Regression
taxi_weather_engineered := Taxi_Weather.ds.engineered;
//Max number of iterations
max_itr_bi := 100;
//Threshold
threshold_bi := 0.0000001;
//Training
logistic_model := Utils.logisticModel(max_itr_bi , threshold_bi);
train_model := logistic_model.fit(taxi_weather_engineered);
//Testing
logistic_predict := logistic_model.predict(train_model, taxi_weather_engineered);
OUTPUT(logistic_predict);
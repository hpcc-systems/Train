IMPORT Data_Modules.Sample_Weather;

//Analyze the data
Sample_Weather_validate := Sample_Weather.ds.validate;
//Aggregate the total taxi trips per day
trips_per_day := TABLE(Sample_Weather_validate, {date, INTEGER trips := COUNT(GROUP)}, date);
OUTPUT(trips_per_day, NAMED('Analysis_Trips_Per_Day'));
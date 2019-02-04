IMPORT Data_Modules.Sample_Weather;
IMPORT Utils;


//Data Validation:
d := Sample_weather.ds.raw;
Sample_weather_valid := Utils.Validation(d);
OUTPUT(Sample_weather_valid,,Sample_Weather.Paths.validate,OVERWRITE);

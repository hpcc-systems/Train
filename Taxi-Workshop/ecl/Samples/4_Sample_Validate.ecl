IMPORT ML_Core.Types AS Types;
IMPORT STD;

//Data Validation
//Read integrated data
//Define dataframe
lsample_weather_raw := RECORD
  Types.t_RecordID id := 0;
  Std.Date.Date_t         date;
  Std.Date.Seconds_t      minutes_after_midnight;
  STRING                  summary;                // 1 Breezy; 2	Clear; 3 Possible; 4 Snow; 5 Windy; 6 ''; 7	Mostly;
                                                  // 8 Heavy; 9 Humid; 10 Overcast;11	Foggy; 12 Light; 13	Partly; 14 Rain
  DECIMAL6_3              temperature;            // Fahrenheit
  UDECIMAL6_3             precipIntensity;        // [0.00, 92.03]
  STRING                  precipType;             // '', 'SNOW' , 'RAIN'
  UDECIMAL4_2             windSpeed;              // MPH [0.00 - 87.75]
  UDECIMAL4_2             visibility;             // Miles [0.00 - 20.23]
  UDECIMAL4_2             cloudCover;             // [0.00 - 1.00]
END;
d := DATASET('~sample_weather_raw', lsample_weather_raw, THOR);

//Define validation dataframe
lvalidate := RECORD(lsample_weather_raw)
    BOOLEAN isValidDate;
    BOOLEAN isValidminutes_after_midnight;
    BOOLEAN isValidSummary;
    BOOLEAN isValidTemp;
    BOOLEAN isValidPrecipIntensity;
    BOOLEAN isValidPrecipType;
    BOOLEAN isValidWindSpeed;
    BOOLEAN isValidVisibility;
    BOOLEAN isValidCloudCover;
END;
Validation(DATASET(lsample_Weather_raw) tw) := FUNCTION
  SET OF STRING summaries := ['Breezy', 'Clear', 'Possible', 'Snow', 'Windy', '', 'Mostly',
                  'Heavy', 'Humid', 'Overcast', 'Foggy', 'Light', 'Partly', 'Rain'];
  preValid :=PROJECT(tw, TRANSFORM(lvalidate,
                      SELF.isValidDate := IF( LEFT.date >= 20150101 AND LEFT.date <= 20160631, TRUE, FALSE),
                      SELF.isValidminutes_after_midnight  := IF( LEFT.minutes_after_midnight >=0 AND LEFT.minutes_after_midnight <=1440, TRUE, FALSE),
                      SELF.isValidSummary   := IF( LEFT.summary IN summaries, TRUE, FALSE),
                      SELF.isValidTemp  := IF( LEFT.temperature >= -50 AND LEFT.temperature <= 150, TRUE, FALSE) ,
                      SELF.isValidPrecipIntensity  :=IF( LEFT.precipIntensity >=0 AND LEFT.precipIntensity <= 100, TRUE, FALSE),
                      SELF.isValidPrecipType  :=IF( LEFT.precipType = '' OR LEFT.precipType = 'rain' OR LEFT.precipType = 'snow', TRUE, FALSE) ,
                      SELF.isValidWindSpeed   :=IF( LEFT.windSpeed >= 0 AND LEFT.windSpeed <= 100, TRUE, FALSE) ,
                      SELF.isValidVisibility  :=IF( LEFT.visibility >= 0 AND LEFT.windSpeed <= 35, TRUE, FALSE),
                      SELF.isValidCloudCover  := IF( LEFT.visibility >= 0 AND LEFT.windSpeed <= 1, TRUE, FALSE),
                      SELF := LEFT));
  filtered := preValid(isValidDate = TRUE AND isValidminutes_after_midnight = TRUE AND isValidSummary = TRUE
                  AND  isValidTemp = TRUE AND isValidPrecipIntensity = TRUE AND isValidWindSpeed = TRUE
                  AND  isValidVisibility = TRUE AND isValidCloudCover = TRUE);
  RETURN filtered;
END;
//Validate raw data
Sample_weather_valid := Validation(d);
//OUTPUT validated data
OUTPUT(CHOOSEN(Sample_weather_valid,100),NAMED('Sample_Validate'));

IMPORT ML_Core;
IMPORT STD;
IMPORT DataPatterns;

//Data Profiling
//Read Data
//Dataframe
lsample_weather_raw := RECORD
  ML_Core.Types.t_RecordID id := 0;
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
Sample_Weather_validate:=DATASET('~sample_weather_valid', lvalidate, THOR);
//Profile data
Sample_Weather_profile:= DataPatterns.Profile(Sample_Weather_validate);
//OUTPUT profiling result
OUTPUT(Sample_Weather_profile,NAMED('Sample_Profile'));
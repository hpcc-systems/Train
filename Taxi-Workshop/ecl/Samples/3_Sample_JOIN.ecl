IMPORT ML_Core.Types;
IMPORT ML_Core;
IMPORT STD;

//Read Preprocessed Taxi sample data
lpreprocess := RECORD
    Std.Date.Date_t    date;
    Std.Date.Time_t    pickup_time;
    UNSIGNED2 pickup_minutes_after_midnight;
END;
sample_preprocess := DATASET('~sample_preprocess', lpreprocess, THOR);

//Read Weahter data
raw := RECORD
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
weather_raw := DATASET('~weather_new_york_city.txt', raw, CSV(HEADING(1)));

//Integrate the two Source Datasets
Sample_join_weather :=  JOIN
(
  sample_preprocess,
  Weather_raw,
  LEFT.date = RIGHT.date AND
  RIGHT.minutes_after_midnight BETWEEN
  LEFT.pickup_minutes_after_midnight - 30 AND
  LEFT.pickup_minutes_after_midnight + 30,
  TRANSFORM
  (
      {raw, Types.t_RecordID id := 0},
      SELF.date:= RIGHT.date,
      SELF.minutes_after_midnight := RIGHT.minutes_after_midnight,
      SELF.summary := RIGHT.summary,
      SELF.temperature := RIGHT.temperature,
      SELF.precipIntensity := RIGHT.precipIntensity,
      SELF.precipType := RIGHT.precipType,
      SELF.windSpeed := RIGHT.windSpeed,
      SELF.visibility := RIGHT.visibility,
      SELF.cloudCover := RIGHT.cloudCover,
      SELF := LEFT
  ),
  LEFT OUTER
);
//Add ID for each record
ML_Core.AppendSeqid(sample_join_weather, id, sw);
//OUTPUT the combined dataset
OUTPUT(sw,NAMED('Sample_JOIN'));
IMPORT Data_Modules.Sample_Weather;
IMPORT Data_Modules.Samples;
IMPORT Data_Modules.Weather;
IMPORT ML_Core;

//Sample data
sample_preprocess := Samples.ds.preprocess;
//Weahter data
Weather_raw := Weather.ds.raw;
//Integrate the Source Datasets
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
      Sample_Weather.Layouts.raw,
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
ML_Core.AppendSeqid(sample_join_weather, id, sample_weather_raw);
OUTPUT(Sample_weather_raw,,Sample_weather.Paths.raw, NAMED('Sample_JOIN'), OVERWRITE);
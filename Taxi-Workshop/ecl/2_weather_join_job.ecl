IMPORT schema;
IMPORT Std;

taxi_weather_ds := JOIN
    (
        schema.taxi_clean.ds,
        schema.weather.ds,
        LEFT.pickup_date = RIGHT.Date AND 
        RIGHT.minutes_after_midnight BETWEEN 
         LEFT.pickup_minutes_after_midnight - 30 AND 
         LEFT.pickup_minutes_after_midnight + 30,
        TRANSFORM
        (
            schema.taxi_weather.layout,
            SELF.vendor_id := LEFT.vendor_id,
            SELF.pickup_date := LEFT.pickup_date,
            SELF.pickup_time := LEFT.pickup_time,
            SELF.pickup_minutes_after_midnight := LEFT.pickup_minutes_after_midnight,
            SELF.weather_summary := RIGHT.summary
        ),
        LOOKUP, LEFT OUTER
    );

OUTPUT(taxi_weather_ds,,
   schema.taxi_weather.file_path, 
   NAMED('after_weather_append'),THOR, COMPRESSED, OVERWRITE);


   
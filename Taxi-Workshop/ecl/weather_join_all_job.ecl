IMPORT schema_all;
IMPORT Std;

taxi_weather_ds := JOIN
    (
        schema_all.taxi_clean.ds,
        schema_all.weather.ds,
        LEFT.pickup_date = RIGHT.weather_date AND 
        RIGHT.weather_minutes_after_midnight BETWEEN 
         LEFT.pickup_minutes_after_midnight - 30 AND 
         LEFT.pickup_minutes_after_midnight + 30,
        TRANSFORM
        (
            schema_all.taxi_weather.layout,
            SELF := LEFT,
            SELF := RIGHT
        ),
        LOOKUP, LEFT OUTER 
    );

OUTPUT(taxi_weather_ds,,
   schema_all.taxi_weather.file_path, 
   NAMED('after_weather_append'),THOR, COMPRESSED, OVERWRITE);
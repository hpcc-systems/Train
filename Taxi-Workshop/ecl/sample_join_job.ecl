IMPORT STD;

taxi_clean := MODULE 
    EXPORT file_path := 
     '~achala::taxi_tutorial::out::sample_clean_yellow_tripdata.flat';
    EXPORT layout := RECORD
        UNSIGNED1   vendor_id;
        Std.Date.Date_t    pickup_date;
        Std.Date.Time_t    pickup_time;
        UNSIGNED2 pickup_minutes_after_midnight; 
    END;
    EXPORT ds := DATASET(file_path,layout,FLAT);
END;

weather := MODULE 
    EXPORT logical_file_path := 
        '~taxi_tutorial::in::weather_new_york_city.csv';
    EXPORT layout := RECORD
        Std.Date.Date_t         date;
        Std.Date.Seconds_t      minutes_after_midnight;
        STRING                  summary;
    END;    
    EXPORT ds := DATASET(logical_file_path, 
        layout, CSV(SEPARATOR([',','\t']),QUOTE('')));
END;

taxi_weather := MODULE
    EXPORT file_path := 
     '~achala::taxi_tutorial::out::sample_clean_weather_yellow_tripdata.flat';
    EXPORT layout := RECORD
        UNSIGNED1   vendor_id;
        Std.Date.Date_t    pickup_date;
        Std.Date.Time_t    pickup_time;
        UNSIGNED2 pickup_minutes_after_midnight; 
        STRING    weather_summary;
    END;
    EXPORT ds := DATASET(file_path,layout,FLAT);
END;

taxi_weather_ds := JOIN
    (
        taxi_clean.ds,
        weather.ds,
        LEFT.pickup_date = RIGHT.Date AND 
        RIGHT.minutes_after_midnight BETWEEN 
         LEFT.pickup_minutes_after_midnight - 30 AND 
         LEFT.pickup_minutes_after_midnight + 30,
        TRANSFORM(
            taxi_weather.layout,
            SELF.vendor_id := LEFT.vendor_id,
            SELF.pickup_date := LEFT.pickup_date,
            SELF.pickup_time := LEFT.pickup_time,
            SELF.pickup_minutes_after_midnight := LEFT.pickup_minutes_after_midnight,
            SELF.weather_summary := RIGHT.summary
        ),
        LOOKUP, LEFT OUTER
    );

OUTPUT(taxi_weather_ds,,
   taxi_weather.file_path, 
   NAMED('after_weather_append'),THOR, COMPRESSED, OVERWRITE);




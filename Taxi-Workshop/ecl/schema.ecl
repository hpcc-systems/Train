IMPORT STD;

EXPORT schema := MODULE 

    EXPORT taxi_raw := MODULE 
        EXPORT file_path := 
        '~taxi_tutorial::in::yellow_tripdata_2016-06.csv';
        EXPORT layout := RECORD
            STRING vendor_id;
            STRING tpep_pickup_datetime;
        END;
        EXPORT ds := DATASET(file_path,
            layout, CSV(HEADING(1)));
    END;

    EXPORT taxi_clean := MODULE 
        EXPORT file_path := 
        '~achala::taxi_tutorial::out::clean_yellow_tripdata_2016-06.flat';
        EXPORT layout := RECORD
            UNSIGNED1   vendor_id;
            Std.Date.Date_t    pickup_date;
            Std.Date.Time_t    pickup_time;
            UNSIGNED2 pickup_minutes_after_midnight; 
        END;
        EXPORT ds := DATASET(file_path,layout,FLAT);
    END;

    EXPORT weather := MODULE 
        EXPORT file_path := 
            '~taxi_tutorial::in::weather_new_york_city.csv';
        EXPORT layout := RECORD
            Std.Date.Date_t         date;
            Std.Date.Seconds_t      minutes_after_midnight;
            STRING                  summary;
        END;    
        EXPORT ds := DATASET(file_path, 
            layout, CSV(SEPARATOR([',','\t']),QUOTE('')));
    END;

    EXPORT taxi_weather := MODULE
        EXPORT file_path := 
        '~achala::taxi_tutorial::out::clean_weather_yellow_tripdata_2016-06.flat';
        EXPORT layout := RECORD
            UNSIGNED1   vendor_id;
            Std.Date.Date_t    pickup_date;
            Std.Date.Time_t    pickup_time;
            UNSIGNED2 pickup_minutes_after_midnight; 
            STRING    weather_summary;
        END;
        EXPORT ds := DATASET(file_path,layout,FLAT);
    END;

END;

IMPORT STD;

EXPORT schema_all := MODULE 

    EXPORT taxi_raw := MODULE 
        EXPORT file_path := 
        '~taxi_tutorial::in::yellow_tripdata_2016-06.csv';
        EXPORT layout := RECORD
        STRING  vendor_id;
        STRING  tpep_pickup_datetime;
        STRING  tpep_dropoff_datetime;
        STRING  passenger_count;
        STRING  trip_distance;
        STRING  pickup_longitude;
        STRING  pickup_latitude;
        STRING  rate_code_id;
        STRING  store_and_fwd_flag;
        STRING  dropoff_longitude;
        STRING  dropoff_latitude;
        STRING  payment_type;
        STRING  fare_amount;
        STRING  extra;
        STRING  mta_tax;
        STRING  tip_amount;
        STRING  tolls_amount;
        STRING  improvement_surcharge;
        STRING  total_amount;
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
            Std.Date.Date_t    dropoff_date;
            Std.Date.Time_t    dropoff_time;
            UNSIGNED1   passenger_count;
            DECIMAL10_2 trip_distance;
            DECIMAL9_6  pickup_longitude;
            DECIMAL9_6  pickup_latitude;
            UNSIGNED1   rate_code_id;
            STRING1     store_and_fwd_flag;
            DECIMAL9_6  dropoff_longitude;
            DECIMAL9_6  dropoff_latitude;
            UNSIGNED1   payment_type;
            DECIMAL8_2  fare_amount;
            DECIMAL8_2  extra;
            DECIMAL8_2  mta_tax;
            DECIMAL8_2  tip_amount;
            DECIMAL8_2  tolls_amount;
            DECIMAL8_2  improvement_surcharge;
            DECIMAL8_2  total_amount;
            
            UNSIGNED2 pickup_minutes_after_midnight;            
            UNSIGNED2 dropoff_minutes_after_midnight;
            UNSIGNED2 pickup_time_hour;
            UNSIGNED2 dropoff_time_hour;
            UNSIGNED2 pickup_day_of_week;
            UNSIGNED2 dropoff_day_of_week;         
            UNSIGNED2 pickup_month_of_year;
            UNSIGNED2 dropoff_month_of_year;
            UNSIGNED2 pickup_year;
            UNSIGNED2 dropoff_year;
            UNSIGNED2 pickup_day_of_month;
            UNSIGNED2 dropoff_day_of_month; 
        END;
        EXPORT ds := DATASET(file_path,layout,FLAT);
    END;

    EXPORT weather := MODULE 
        EXPORT file_path := 
            '~taxi_tutorial::in::weather_new_york_city.csv';
        EXPORT layout := RECORD
            Std.Date.Date_t         weather_date;
            Std.Date.Seconds_t      weather_minutes_after_midnight;
            STRING                  weather_summary;
            UDECIMAL6_3             weather_temperature;
            UDECIMAL6_3             weather_precipIntensity;
            STRING                  weather_precipType;
            UDECIMAL4_2             weather_windSpeed;
            UDECIMAL4_2             weather_visibility;
            UDECIMAL4_2             weather_cloudCover;
        END;    
        EXPORT ds := DATASET(file_path, 
            layout, CSV(SEPARATOR([',','\t']),QUOTE('')));
    END;

    EXPORT taxi_weather := MODULE
        EXPORT file_path := 
        '~achala::taxi_tutorial::out::clean_weather_yellow_tripdata_2016-06.flat';
        EXPORT layout := RECORD
            taxi_clean.layout;
            weather.layout;
        END;
        EXPORT ds := DATASET(file_path,layout,FLAT);
    END;

END;

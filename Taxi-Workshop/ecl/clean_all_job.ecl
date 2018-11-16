IMPORT schema_all;
IMPORT Std;

taxi_clean_ds := PROJECT
    (
        schema_all.taxi_raw.ds, 
        TRANSFORM
        (
            schema_all.taxi_clean.layout,
            SELF.vendor_id := (INTEGER)LEFT.vendor_id;

            SELF.pickup_date  := 
            Std.Date.FromStringToDate(
                LEFT.tpep_pickup_datetime[..10], '%Y-%m-%d');
            SELF.pickup_time := 
            Std.Date.FromStringToTime(
                LEFT.tpep_pickup_datetime[12..], '%H:%M:%S');
            SELF.dropoff_date  := 
            Std.Date.FromStringToDate(
                LEFT.tpep_dropoff_datetime[..10], '%Y-%m-%d');
            SELF.dropoff_time := 
            Std.Date.FromStringToTime(
                LEFT.tpep_dropoff_datetime[12..], '%H:%M:%S');
            passenger_count := (UNSIGNED1)LEFT.passenger_count;
            
            SELF.passenger_count := IF(passenger_count <= 0, 1, passenger_count);
            SELF.trip_distance := (DECIMAL10_2)LEFT.trip_distance;
            SELF.pickup_longitude := (DECIMAL9_6)LEFT.pickup_longitude;
            SELF.pickup_latitude := (DECIMAL9_6)LEFT.pickup_latitude;
            SELF.rate_code_id := (UNSIGNED1)LEFT.rate_code_id;
            SELF.store_and_fwd_flag := (STRING1)LEFT.store_and_fwd_flag;
            SELF.dropoff_longitude := (DECIMAL9_6)LEFT.dropoff_longitude;
            SELF.dropoff_latitude := (DECIMAL9_6)LEFT.dropoff_latitude;
            SELF.payment_type := (UNSIGNED1)LEFT.payment_type;
            SELF.fare_amount := (DECIMAL8_2)LEFT.fare_amount;
            SELF.extra:= (DECIMAL8_2)LEFT.extra;
            SELF.mta_tax := (DECIMAL8_2)LEFT.mta_tax;
            SELF.tip_amount := (DECIMAL8_2)LEFT.tip_amount;
            SELF.tolls_amount := (DECIMAL8_2)LEFT.tolls_amount;
            SELF.improvement_surcharge := (DECIMAL8_2)LEFT.improvement_surcharge;
            SELF.total_amount := (DECIMAL8_2)LEFT.total_amount;

            //Time append
            SELF.pickup_minutes_after_midnight 
                := Std.Date.Hour(SELF.pickup_time) 
                    * 60 + Std.Date.Minute(SELF.pickup_time);
            SELF.dropoff_minutes_after_midnight 
                := Std.Date.Hour(SELF.dropoff_time)           
                * 60 + Std.Date.Minute(SELF.dropoff_time);
            SELF.pickup_time_hour := Std.Date.Hour(SELF.pickup_time);
            SELF.dropoff_time_hour := Std.Date.Hour(SELF.dropoff_time);
            SELF.pickup_day_of_week := Std.Date.DayOfWeek(SELF.pickup_date);
            SELF.dropoff_day_of_week := Std.Date.DayOfWeek(SELF.dropoff_date);
            SELF.pickup_month_of_year := Std.Date.Month(SELF.pickup_date);
            SELF.dropoff_month_of_year := Std.Date.Month(SELF.dropoff_date);
            SELF.pickup_year := Std.Date.Year(SELF.pickup_date);
            SELF.dropoff_year := Std.Date.Year(SELF.dropoff_date); 
            SELF.pickup_day_of_month := Std.Date.Day(SELF.pickup_date); 
            SELF.dropoff_day_of_month := Std.Date.Day(SELF.dropoff_date);
        ) 
    );

OUTPUT(taxi_clean_ds,, schema_all.taxi_clean.file_path, 
 NAMED('after_clean'),THOR, COMPRESSED, OVERWRITE);
IMPORT STD;

//READ the Sample Taxi Data
//Define dataframe
Layout:= RECORD
    STRING  VendorID;                   // Franchisee ID (?)
    STRING  tpep_pickup_datetime;
    STRING  tpep_dropoff_datetime;
    STRING  passenger_count;
    STRING  trip_distance;              // Scale:  miles
    STRING  pickup_longitude;
    STRING  pickup_latitude;
    STRING  rate_code_id;
    STRING  store_and_fwd_flag;         // Y/N
    STRING  dropoff_longitude;
    STRING  dropoff_latitude;
    STRING  payment_type;               // 1 = credit; 2 = cash; there are others
    STRING  fare_amount;
    STRING  extra;
    STRING  mta_tax;
    STRING  tip_amount;
    STRING  tolls_amount;
    STRING  improvement_surcharge;
    STRING  total_amount;
END;
//Read the sample data
Sample_raw := DATASET('~yellow_tripdata_2016-06.csv', layout, CSV(HEADING(1)));

//Define the dataframe for the processed data
lpreprocess := RECORD
    Std.Date.Date_t    date;
    Std.Date.Time_t    pickup_time;
    UNSIGNED2 pickup_minutes_after_midnight;
END;
//PROJECT W/ TRANSFORM to Manupulate the data
preprocess := PROJECT
    (
    Sample_raw(tpep_pickup_datetime <> ''),   //Filter out empty data
    TRANSFORM
        (
            lpreprocess,
            SELF.date :=
                    Std.Date.FromStringToDate(LEFT.tpep_pickup_datetime[..10], '%Y-%m-%d'),
            SELF.pickup_time :=
                    Std.Date.FromStringToTime(LEFT.tpep_pickup_datetime[12..], '%H:%M:%S'),
            SELF.pickup_minutes_after_midnight:= Std.Date.Hour(SELF.pickup_time)
                    * 60 + Std.Date.Minute(SELF.pickup_time);
        )
    );

OUTPUT(CHOOSEN(preprocess,100), NAMED('Sample_Project'));
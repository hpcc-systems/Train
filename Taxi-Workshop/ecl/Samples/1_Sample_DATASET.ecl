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
//Define data directory
path := '~yellow_tripdata_2016-06.csv';
//Read the sample data
Sample_raw := DATASET(path, layout, CSV(HEADING(1)));
//OUTPUT the sample data
OUTPUT(Sample_raw, NAMED('Sample_Dataset'));

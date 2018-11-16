
//Simple File Read

// taxi_ds := DATASET('~achala::taxi_tutorial::in::sample_yellow_tripdata.csv',
//      {STRING line}, CSV(SEPARATOR('')));

// OUTPUT(taxi_ds);

//Read file and count number of records

// taxi_ds := DATASET('~achala::taxi_tutorial::in::sample_yellow_tripdata.csv',
//      {STRING line}, CSV(SEPARATOR('')));

// OUTPUT(COUNT(taxi_ds));

//Read and extract 2 fields
// taxi_ds := DATASET('~achala::taxi_tutorial::in::sample_yellow_tripdata.csv',
//      {STRING vendor_id, STRING tpep_pickup_datetime}, CSV(SEPARATOR(',')));


// OUTPUT(taxi_ds);


//Use a RECORD definition to read 
taxi_layout := RECORD
    STRING vendor_id;
    STRING tpep_pickup_datetime;
END;

taxi_ds := DATASET('~achala::taxi_tutorial::in::sample_yellow_tripdata.csv',
     taxi_layout, CSV(HEADING(1)));

OUTPUT(taxi_ds);

//Use MODULE to encapsulate code
taxi := MODULE 
    layout := RECORD
        STRING vendor_id;
        STRING tpep_pickup_datetime;
    END;

    EXPORT ds := DATASET('~achala::taxi_tutorial::in::sample_yellow_tripdata.csv',
        layout, CSV(HEADING(1)));
END;

OUTPUT(taxi.ds);




















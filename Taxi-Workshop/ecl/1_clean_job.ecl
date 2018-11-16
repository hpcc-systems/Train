IMPORT schema;
IMPORT Std;

taxi_clean_ds := PROJECT
    (
        schema.taxi_raw.ds, 
        TRANSFORM
        (
            schema.taxi_clean.layout,
            SELF.vendor_id := (INTEGER)LEFT.vendor_id,
            SELF.pickup_date := 
             Std.Date.FromStringToDate(LEFT.tpep_pickup_datetime[..10], '%Y-%m-%d'),
            SELF.pickup_time := 
             Std.Date.FromStringToTime(LEFT.tpep_pickup_datetime[12..], '%H:%M:%S'),            
            SELF.pickup_minutes_after_midnight:= Std.Date.Hour(SELF.pickup_time) 
             * 60 + Std.Date.Minute(SELF.pickup_time); 
        ) 
    );

OUTPUT(taxi_clean_ds,, schema.taxi_clean.file_path, 
 NAMED('after_clean'),THOR, COMPRESSED, OVERWRITE);



 
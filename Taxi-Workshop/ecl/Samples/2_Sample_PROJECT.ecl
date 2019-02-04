IMPORT Data_Modules.Samples;
IMPORT Data_Modules.Taxi;
IMPORT STD;

//Sample Taxi Data
Sample_raw := Samples.ds.raw;
//PROJECT W/ TRANSFORM to Manupulate the data
preprocess := PROJECT
    (
    Sample_raw(tpep_pickup_datetime <> ''),   //Filter out empty data
    TRANSFORM
        (
            Taxi.Layouts.Preprocess,
            SELF.date :=
                    Std.Date.FromStringToDate(LEFT.tpep_pickup_datetime[..10], '%Y-%m-%d'),
            SELF.pickup_time :=
                    Std.Date.FromStringToTime(LEFT.tpep_pickup_datetime[12..], '%H:%M:%S'),
            SELF.pickup_minutes_after_midnight:= Std.Date.Hour(SELF.pickup_time)
                    * 60 + Std.Date.Minute(SELF.pickup_time);
        )
    );

OUTPUT(preprocess,, Samples.Paths.preprocess, NAMED('Sample_Project'), OVERWRITE);
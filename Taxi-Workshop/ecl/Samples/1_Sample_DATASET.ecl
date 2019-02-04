IMPORT Data_Modules.Samples;

//READ Sample Taxi Data
Sample_raw := Samples.ds.raw;
//OUTPUT the data
OUTPUT(Sample_raw, NAMED('Read_Raw_Sample'));

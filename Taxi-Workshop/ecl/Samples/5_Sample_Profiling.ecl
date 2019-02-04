IMPORT Data_Modules.Sample_Weather;
IMPORT DataPatterns;

//Data Profiling
Sample_Weather_validate:= Sample_Weather.ds.validate;
Sample_Weather_profile:= DataPatterns.Profile(Sample_Weather_validate);
OUTPUT(Sample_Weather_profile,, Sample_Weather.Paths.profile, OVERWRITE);
IMPORT schema_all;

busyDays := TABLE
    (
        schema_all.taxi_weather.ds,
        {
            pickup_day_of_week,
            UNSIGNED4   cnt := COUNT(GROUP),
        },
        pickup_day_of_week 
    ) : PERSIST('BusyDays');

OUTPUT(busyDays, NAMED('busydays_1'));

namedBusyDays := PROJECT(busyDays, 
      TRANSFORM({STRING weekday, UNSIGNED4 cnt}, 
      SELF.weekday := CASE(LEFT.pickup_day_of_week, 
            1 => 'Sun', 
            2 => 'Mon', 
            3 => 'Tue', 
            4 => 'Wed', 
            5 => 'Thur', 
            6 => 'Fri', 
            'Sat'); 
      SELF.cnt := LEFT.cnt));    

OUTPUT(namedBusyDays, NAMED('busydays'));
//Visualizer.Visualizer.TwoD.pie('busydays',, 'busydays');



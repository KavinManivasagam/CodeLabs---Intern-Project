IMPORT STD;
IMPORT Visualizer;
IMPORT ML_Core;

Layout_ProjectTransform := RECORD
    STRING15 Date;
    STRING15 Region;
    STRING15 TGA; //ACTUAL THERMAL GENERATION
    STRING15 TGE;
    STRING15 NGA; //ACTUAL NUCLEAR GENERATION
    STRING15 NGE;
    STRING15 HGA; //ACTUAL HYDRO GENERATION
    STRING15 HGE;

END;


//OUTPUT(first);
ProjectTransform := DATASET('~kavin::test::file::file.csv',Layout_ProjectTransform,CSV(HEADING(1),SEPARATOR(','),QUOTE('"')));

OUTPUT(ProjectTransform,NAMED('dsRead'));

NewLayout:= RECORD
    UNSIGNED4 Date;
    STRING15 Region;
    STRING15 TGA; //ACTUAL THERMAL GENERATION
    STRING15 TGE;
    STRING15 NGA; //ACTUAL NUCLEAR GENERATION
    STRING15 NGE;
    STRING15 HGA; //ACTUAL HYDRO GENERATION
    STRING15 HGE;
END;


ID_ProjectTransform := PROJECT(ProjectTransform,
                        TRANSFORM(
                            NewLayout,

                            SELF.Date := STD.Date.FromStringToDate(LEFT.Date, '%Y-%m-%d'),
                            SELF.TGA := IF(LEFT.TGA ='NaN', ' ',STD.Str.FindReplace(LEFT.TGA, '0', ' ' ));
                            SELF.TGE := IF(LEFT.TGE ='NaN', ' ',STD.Str.FindReplace(LEFT.TGE, '0', ' ' ));
                            SELF.NGA := IF(LEFT.NGA ='NaN', ' ',STD.Str.FindReplace(LEFT.NGA, '0', ' ' ));
                            SELF.NGE := IF(LEFT.NGE ='NaN', ' ',STD.Str.FindReplace(LEFT.NGE, '0', ' ' ));
                            SELF.HGA := IF(LEFT.HGA ='NaN', ' ',STD.Str.FindReplace(LEFT.HGA, '0', ' ' ));
                            SELF.HGE := IF(LEFT.HGE ='NaN', ' ',STD.Str.FindReplace(LEFT.HGE, '0', ' ' ));

                            SELF := LEFT;
                        ));

OUTPUT(ID_ProjectTransform,NAMED('dsClean'));

AnalyticsRec:= RECORD
    UNSIGNED4 Date;
    STRING15 Region;
    INTEGER TGA; //ACTUAL THERMAL GENERATION
    STRING15 TGE;
    STRING15 NGA; //ACTUAL NUCLEAR GENERATION
    STRING15 NGE;
    STRING15 HGA; //ACTUAL HYDRO GENERATION
    STRING15 HGE;
    INTEGER  Trans_DOW;
    INTEGER  Trans_month;
    INTEGER  Trans_Year;
    INTEGER RegionInt;
END;


getDataCollected := PROJECT(ID_ProjectTransform,
                        TRANSFORM(
                            AnalyticsRec,
                            SELF.Trans_DOW   := Std.Date.DayOfWeek(LEFT.date);
                            SELF.Trans_month := Std.Date.Month(LEFT.date) ;
                            SELF.Trans_Year  := Std.Date.Year(LEFT.date);
                            SELF.TGA := (INTEGER) Left.TGA;
                            SELF.RegionInt := CASE((LEFT.Region), 'Western'=> 1, 
                                                                'Southern' => 2, 
                                                                'Eastern'=> 3, 
                                                                'Northern' => 4, 
                                                                'NorthEastern' => 5,
                                                                0),
                            SELF := LEFT;
                        ));



OUTPUT(getDataCollected,NAMED('dsEnrich'));

getGroupedData := TABLE(getDataCollected,
                            {
                              getDataCollected.region;
                              getDataCollected.Trans_month;
                              INTEGER Cnt := COUNT(GROUP);
                              INTEGER MaxThermal := MAX(GROUP,getDataCollected.TGA );
                              INTEGER MaxNuclear := MAX(GROUP,getDataCollected.NGA);
                              INTEGER MaxHydro := MAX(GROUP,getDataCollected.HGA);
                            },region,Trans_month);

OUTPUT(getGroupedData,NAMED('dsAnalyze'));








//  Aggregate by Region ---
OUTPUT(TABLE(getDataCollected, {Region, UNSIGNED Cnt := COUNT(GROUP)}, Region, FEW), NAMED('Region'));
Visualizer.MultiD.Bar('myBarChart',, 'Region');
dsSortPerDate := SORT(TABLE(getDataCollected,{date, RegionInt},date, RegionInt),date, RegionInt);
assignSequentialNumberPerDate := PROJECT(
                                    dsSortPerDate,
                                    TRANSFORM(
                                        {UNSIGNED4 Num,unsigned4 date, INTEGER RegionInt},
                                        SELF.Num := COUNTER,
                                        SELF := LEFT
                                        ));

ML_Core.Types.NumericField XF(getDataCollected L, integer C) := TRANSFORM
   SELF.id := C;
   SELF.number := assignSequentialNumberPerDate(date = L.date)[1].Num;
   SELF.value :=  assignSequentialNumberPerDate(RegionInt = L.RegionInt)[1].Num;

   SELF.wi:=1;
END;
getSequentialNumberForAll := PROJECT(getDataCollected,XF(LEFT,COUNTER));

simpleAggregations := ML_Core.FieldAggregates(getSequentialNumberForAll).Simple;

OutputRec := RECORD
    RECORDOF(simpleAggregations);
    unsigned4 date;
END;
AggregateRes := JOIN(simpleAggregations,
                    assignSequentialNumberPerDate,
                    LEFT.number = RIGHT.num,
                    TRANSFORM(
                        RECORDOF(OutputRec),
                        SELF.date := RIGHT.date,
                        SELF:=LEFT
                    ),INNER);

/**View the Result in the work unit**/
OUTPUT(AggregateRes,NAMED('AggregateRes'));
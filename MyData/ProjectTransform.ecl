IMPORT STD;
IMPORT Visualizer;


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

OUTPUT(ProjectTransform,NAMED('ProjectTransform'));

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

ID_ProjectTransform;

AnalyticsRec:= RECORD
    UNSIGNED4 Date;
    STRING15 Region;
    STRING15 TGA; //ACTUAL THERMAL GENERATION
    STRING15 TGE;
    STRING15 NGA; //ACTUAL NUCLEAR GENERATION
    STRING15 NGE;
    STRING15 HGA; //ACTUAL HYDRO GENERATION
    STRING15 HGE;
    INTEGER  Trans_DOW;
    INTEGER  Trans_month;
    INTEGER  Trans_Year;
END;



getDataCollected := PROJECT(ID_ProjectTransform,
                        TRANSFORM(
                            AnalyticsRec,
                            SELF.Trans_DOW   := Std.Date.DayOfWeek(LEFT.date);
                            SELF.Trans_month := Std.Date.Month(LEFT.date) ;
                            SELF.Trans_Year  := Std.Date.Year(LEFT.date);

                            SELF := LEFT;
                        ));

getDataCollected;

getGroupedData := TABLE(getDataCollected,
                            {
                              getDataCollected.region;
                              getDataCollected.Trans_month;
                              INTEGER Cnt := COUNT(GROUP);
                              INTEGER MaxThermal := MAX(GROUP,getDataCollected.TGA );
                              INTEGER MaxNuclear := MAX(GROUP,getDataCollected.NGA);
                              INTEGER MaxHydro := MAX(GROUP,getDataCollected.HGA);
                            },region,Trans_month);
getGroupedData;

ds11 := DATASET([{'TGA', 'ACTUAL THERMAL GENERATION'},
                {'NGA', 'ACTUAL NUCLEAR GENERATION'},
                {'HGA', 'ACTUAL HYDRO GENERATION'}],{STRING5 Code, STRING Desc});


OUTPUT(TABLE(getDataCollected, {Region, UNSIGNED Cnt := COUNT(GROUP)}, Region, FEW), NAMED('Region'));
Visualizer.MultiD.Bar('myBarChart',, 'Region');
IMPORT STD;


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

                            //SELF.HGE := STD.Str.Splitwords(LEFT.HGE, ',')[2];
                            
                            



                            SELF := LEFT;
                        ));

ID_ProjectTransform;

//Highest HGA
getLargeHGAs := TABLE(ProjectTransform,{ HGA,DistinctColCnt := COUNT(GROUP) },HGA);

HighestHGA :=getLargeHGAs(DistinctColCnt = MAX(getLargeHGAs,DistinctColCnt));

OUTPUT(HighestHGA,NAMED('HighestHGA'));

//Highest HGE
getLargeHGEs := TABLE(ProjectTransform,{ HGE,DistinctColCnt := COUNT(GROUP) },HGE);

HighestHGE :=getLargeHGEs(DistinctColCnt = MAX(getLargeHGEs,DistinctColCnt));

OUTPUT(HighestHGE,NAMED('HighestHGE'));
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
EXPORT ProjectTransform := DATASET('~kavin::test::file::file.csv',Layout_ProjectTransform,THOR);



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
                            SELF.Date := STD.Date.FromStringToDate(LEFT.Date, '%Y%m%d'),
                            SELF.TGA := IF(LEFT.TGA ='NaN', '',STD.Str.FindReplace(LEFT.TGA, 'NaN', ' ' ));
                            SELF.TGE := IF(LEFT.TGE ='NaN', '',STD.Str.FindReplace(LEFT.TGE, 'NaN', ' ' ));
                            SELF.NGA := IF(LEFT.NGA ='NaN', '',STD.Str.FindReplace(LEFT.NGA, 'NaN', ' ' ));
                            SELF.NGE := IF(LEFT.NGE ='NaN', '',STD.Str.FindReplace(LEFT.NGE, 'NaN', ' ' ));
                            SELF.HGA := IF(LEFT.HGA ='NaN', '',STD.Str.FindReplace(LEFT.HGA, 'NaN', ' ' ));
                            SELF.HGE := IF(LEFT.HGE ='NaN', '',STD.Str.FindReplace(LEFT.HGE, 'NaN', ' ' ));

                            //SELF.HGE := STD.Str.Splitwords(LEFT.HGE, ',')[2];
                            
                            



                            SELF := LEFT;
                        ));

ID_ProjectTransform;

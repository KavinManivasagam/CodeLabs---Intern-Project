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
                            SELF.TGA := STD.Str.Splitwords(LEFT.TGA, ',')[2];
                            SELF.TGE := STD.Str.Splitwords(LEFT.TGE, ',')[2];
                            SELF.NGA := STD.Str.Splitwords(LEFT.NGA, ',')[2];
                            SELF.NGE := STD.Str.Splitwords(LEFT.NGE, ',')[2];
                            SELF.HGA := STD.Str.Splitwords(LEFT.HGA, ',')[2];
                            SELF.HGE := STD.Str.Splitwords(LEFT.HGE, ',')[2];

                            SELF := LEFT;
                        ));

ID_ProjectTransform;

IMPORT STD;


Layout_ProjectTransform := RECORD
    STRING15 Date;
    STRING15 Region;
    STRING15 TGA; //ACTUAL THERMAL GENERATION
    UDECIMAL6 TGE;
    UDECIMAL4 NGA; //ACTUAL NUCLEAR GENERATION
    UDECIMAL4 NGE;
    UDECIMAL5 HGA; //ACTUAL HYDRO GENERATION
    UDECIMAL5 HGE;

END;


//OUTPUT(first);
EXPORT ProjectTransform := DATASET('~kavin::test::file::file.csv',Layout_ProjectTransform,THOR);



NewLayout:= RECORD
    UNSIGNED4 Date;
    STRING15 Region;
    STRING15 TGA; //ACTUAL THERMAL GENERATION
    UDECIMAL6 TGE;
    UDECIMAL4 NGA; //ACTUAL NUCLEAR GENERATION
    UDECIMAL4 NGE;
    UDECIMAL5 HGA; //ACTUAL HYDRO GENERATION
    UDECIMAL5 HGE;
END;


ID_ProjectTransform := PROJECT(ProjectTransform,
                        TRANSFORM(
                            NewLayout,
                            SELF.Date := STD.Date.FromStringToDate(LEFT.Date, '%Y%m%d'),
                            SELF.TGA := STD.Str.Splitwords(LEFT.TGA, ',')[2];
                            SELF := LEFT;
                        ));

ID_ProjectTransform;

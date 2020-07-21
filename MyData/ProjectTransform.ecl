IMPORT STD;


Layout_first := RECORD
    STRING15 Date;
    STRING15 Region;
    UDECIMAL6 TGA; //ACTUAL THERMAL GENERATION
    UDECIMAL6 TGE;
    UDECIMAL4 NGA; //ACTUAL NUCLEAR GENERATION
    UDECIMAL4 NGE;
    UDECIMAL5 HGA; //ACTUAL HYDRO GENERATION
    UDECIMAL5 HGE;

END;


//OUTPUT(first);
EXPORT first := DATASET('~kavin::test::file::file.csv',Layout_first,THOR);



NewLayout:= RECORD
    UNSIGNED4 Date;
    STRING15 Region;
    UDECIMAL6 TGA; //ACTUAL THERMAL GENERATION
    UDECIMAL6 TGE;
    UDECIMAL4 NGA; //ACTUAL NUCLEAR GENERATION
    UDECIMAL4 NGE;
    UDECIMAL5 HGA; //ACTUAL HYDRO GENERATION
    UDECIMAL5 HGE;
END;


EXPORT ID_first := PROJECT(first,
                        TRANSFORM(
                            NewLayout,
                            SELF.Date := STD.Date.FromStringToDate(LEFT.Date, '%Y-%m-%d', '%Y%m%d');
                            SELF := LEFT;
                        ));

ID_first;

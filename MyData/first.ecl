IMPORT $;

Layout_first := RECORD
    UNSIGNED4 ID;
    $.File_India.Layout;
END;

Layout_first IDRecs($.File_India.Layout L, INTEGER C) ;= TRANSFORM
    SELF.ID := C;
    SELF := L;
END;

EXPORT ID_first := PROJECT($.File_India.File,IDRecs(LEFT,COUNTER))
    //:PERSIST('~CLASS::BMF::PERSIST::ID_first')
/*
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
*/

//OUTPUT(first);
//EXPORT first := DATASET('~kavin::test::file::file.csv',Layout_first,THOR);



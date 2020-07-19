IMPORT STD;

Rec := RECORD
    String line;
END;
dsread := DATASET('~thor::in::test', Rec, CSV(HEADING(1),
                     SEPARATOR([',']),
                     TERMINATOR(['\n','\r\n','\n\r'])));
dsread;
//PROJECT(dsread, TRANSFORM(NewRec), SELF.new := FINDREPLACE, SELF := LEFT));
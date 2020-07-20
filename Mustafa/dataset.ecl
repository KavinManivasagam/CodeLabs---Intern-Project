IMPORT STD;

Rec := RECORD
    STRING date; //not sure if string is most suitable for dates, this is what they chose in lab excercise
    UDECIMAL open;
    UDECIMAL high;
    UDECIMAL low;
    UDECIMAL close;
    UDECIMAL volume;
    INTEGER openint;
    UDECIMAL change;
END;

dsread := DATASET('~thor::in::test', Rec, CSV(HEADING(1),
                     SEPARATOR([',']),
                     TERMINATOR(['\n','\r\n','\n\r'])));
dsread;

/*
Rec CalcChange() := TRANSFORM
    SELF.change := SELF.close - SELF.open;
    SELF := x;
END;
tried to make a transform function here to calculate a change from 2 fields but not really sure what I was doing with it */

PROJECT(dsread, TRANSFORM(Rec, SELF := LEFT));


IMPORT STD;

Rec := RECORD
    STRING date; 
    UDECIMAL open;
    UDECIMAL high;
    UDECIMAL low;
    UDECIMAL close;
    UDECIMAL volume;
    INTEGER openint;
    STRING200 file_name {VIRTUAL(logicalfilename)};
END;

filename := 'thor::IN::*us*';
tempSuperName := NOFOLD('{~' + Std.Str.CombineWords(SET(NOTHOR(STD.FILE.LOGICALFILELIST(filename)), name), ',~')  + '}');
tempSuperName;
dsread := DATASET(tempSuperName, Rec, CSV(HEADING(1),
                     SEPARATOR([',']),
                     TERMINATOR(['\n','\r\n','\n\r'])));
dsread;

NewRec := RECORD
    UNSIGNED4 date; 
    UDECIMAL open;
    UDECIMAL high;
    UDECIMAL low;
    UDECIMAL close;
    UDECIMAL volume;
    STRING15 stockType;
    STRING200 file_name;
END;

//tried to make a transform function here to calculate a change from 2 fields but not really sure what I was doing with it */
// transform is to just change you data and keep it clean like in your case your dare is a string you should convert it into UNSIGNED4 so that it occcupies less space and also helps you use arthimatic functions like between etc.
dsClean := PROJECT(dsread, TRANSFORM(NewRec,
                            SELF.Date := STD.Date.FromStringToDate(LEFT.Date, '%Y-%m-%d');
                            SELF.stockType := STD.Str.Splitwords(LEFT.file_name, '.')[1];//[11..]; // substring manipulation
                            SELF := LEFT;
                        ));

dsClean;


//WT find the best performing day of each stock
//best performing defined as highest closing
performingDays := TABLE(dsClean, {date,close,stockType});

bestPerforming := performingDays(close = MAX(performingDays,close));

OUTPUT(bestPerforming,NAMED('bestPerformingDays'));

//Get Volumne and Stock Of Stock By Stock type 

getStockStatus := TABLE(dsClean,{INTEGER volumne := MAX(GROUP,dsClean.high),INTEGER Cnt := COUNT(GROUP)},stocktype);

getStockStatus;
 
max_record_size := 225000;
IMPORT STD;
STD.File.SprayDelimited('192.168.56.101',
       '/var/lib/HPCCSystems/mydropzone/aadr.us.txt',
       max_record_size ,
       ',',
         '\n',
        '"',
       'mythor',
       'IN::test'
       );

dsread := DATASET('kavin::filenams', RecordStructure, CSV(HEADER(1)));
PROJECT(dsread, TRANSFORM(NewRec), SELF.new := FINDREPLACE, SELF := LEFT));

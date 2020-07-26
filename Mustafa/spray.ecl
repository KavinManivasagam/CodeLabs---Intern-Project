max_record_size := 225000;
IMPORT STD;
// STD.File.SprayDelimited('192.168.56.101',
//        '/var/lib/HPCCSystems/mydropzone/aadr.us.txt',
//        max_record_size ,
//        ',',
//          '\n',
//         '"',
//        'mythor',
//        'IN::test'
//        );
  pfoldername := '/var/lib/HPCCSystems/mydropzone/';
  fileType := 'aadr.us.txt';
  fileCount:= 1;

 

    dirList(STRING pfoldername, STRING fileType) := FUNCTION 
    fList := STD.File.RemoteDirectory
        (
            '192.168.56.101', 
            pfoldername + '/' , '*' + fileType + '*'
        );
      RETURN GLOBAL(SORT(NOTHOR(fList), name), FEW);
    END;


    moveFiles(STRING name, STRING pfoldername) := NOTHOR(
                                                    STD.File.MoveExternalFile(
                                                    '192.168.56.101', 
                                                    pfoldername+'/' + name,
                                                    pfoldername+'/processed/' + name, 
                                                       
                                                    )
                                                );
                    
    doSpray(STRING name, STRING pfoldername) :=
 
            SEQUENTIAL(      
            STD.File.SprayDelimited(
            '192.168.56.101', 
            pfoldername + '/' +name, 
            max_record_size,
            ',',
            '\n',
            '"',
            'mythor', 
            'IN::'+name+'_'+RANDOM(),,,,TRUE, FALSE, FALSE,''),
            moveFiles(name, pfoldername));
           

    // Function that calls spray data and move data 											
    sprayData(STRING pfoldername , STRING fileType, Integer fileCount) := 
                                                    NOTHOR(
															                          APPLY(dirList(pfoldername, fileType)[1..FileCount],
                                                            SEQUENTIAL(
                                                                   doSpray(name, pfoldername),
                                                                )
                                                            )
                                                        );

    // RETURN
     sprayData(pfoldername, fileType, fileCount);

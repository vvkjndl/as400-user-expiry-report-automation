@echo off

:: ################################################################################################
:: Script Repository URL:   https://github.com/vivekjindal/as400-userid-expiry-report-automation
:: ################################################################################################

:: script configuration
set "userid=userid"
set "password=password"
set "libname=libname"
set "filename=usrrptpgm"
set "string1=empty"
set "workpath=x:\reports\%filename%"
mkdir %workpath%\backup > nul 2> nul
set "backuppath=%workpath%\backup"
set "hostfile=%workpath%\%filename%.txt"

:: prepare the pcfile
echo "USERID","ISEXP","DAYSLEFT","HOST","DESCRIPTION" > %workpath%\%filename%.csv

:: record start date/time
set "starttime=%date% %time%"

:: create an ibm i dtf file
echo [DataTransferFromAS400] > %workpath%\%filename%.dtf
echo Version=2.0 >> %workpath%\%filename%.dtf
echo [HostInfo] >> %workpath%\%filename%.dtf
echo Database=*SYSBAS >> %workpath%\%filename%.dtf
echo HostFile=%libname%/%filename% >> %workpath%\%filename%.dtf
echo HostName=%string1% >> %workpath%\%filename%.dtf
echo [ClientInfo] >> %workpath%\%filename%.dtf
echo ASCIITruncation=1 >> %workpath%\%filename%.dtf
echo ConvType=0 >> %workpath%\%filename%.dtf
echo CrtOpt=0 >> %workpath%\%filename%.dtf
echo FDFFile=%workpath%\%filename%.fdf >> %workpath%\%filename%.dtf
echo FDFFormat=1 >> %workpath%\%filename%.dtf
echo FileOps=503209343 >> %workpath%\%filename%.dtf
echo OutputDevice=2 >> %workpath%\%filename%.dtf
echo PCFile=%workpath%\%filename%.csv >> %workpath%\%filename%.dtf
echo PCFileType=12 >> %workpath%\%filename%.dtf
echo SaveFDF=0 >> %workpath%\%filename%.dtf
echo [SQL] >> %workpath%\%filename%.dtf
echo EnableGroup=0 >> %workpath%\%filename%.dtf
echo GroupBy= >> %workpath%\%filename%.dtf
echo Having= >> %workpath%\%filename%.dtf
echo JoinBy= >> %workpath%\%filename%.dtf
echo MissingFields=0 >> %workpath%\%filename%.dtf
echo OrderBy= >> %workpath%\%filename%.dtf
echo SQLSelect= >> %workpath%\%filename%.dtf
echo Select=* >> %workpath%\%filename%.dtf
echo Where= >> %workpath%\%filename%.dtf
echo [Options] >> %workpath%\%filename%.dtf
echo DateFmt=MDY >> %workpath%\%filename%.dtf
echo DateSep=[/] >> %workpath%\%filename%.dtf
echo DecimalSep=. >> %workpath%\%filename%.dtf
echo IgnoreDecErr=1 >> %workpath%\%filename%.dtf
echo Lang=0 >> %workpath%\%filename%.dtf
echo LangID= >> %workpath%\%filename%.dtf
echo SortSeq=0 >> %workpath%\%filename%.dtf
echo SortTable= >> %workpath%\%filename%.dtf
echo TimeFmt=HMS >> %workpath%\%filename%.dtf
echo TimeSep=[:] >> %workpath%\%filename%.dtf
echo [HTML] >> %workpath%\%filename%.dtf
echo AutoSize=0 >> %workpath%\%filename%.dtf
echo AutoSizeKB=128 >> %workpath%\%filename%.dtf
echo CapAlign=0 >> %workpath%\%filename%.dtf
echo CapIncNum=0 >> %workpath%\%filename%.dtf
echo CapSize=6 >> %workpath%\%filename%.dtf
echo CapStyle=1 >> %workpath%\%filename%.dtf
echo Caption= >> %workpath%\%filename%.dtf
echo CellAlignN=0 >> %workpath%\%filename%.dtf
echo CellAlignT=0 >> %workpath%\%filename%.dtf
echo CellSize=6 >> %workpath%\%filename%.dtf
echo CellWrap=1 >> %workpath%\%filename%.dtf
echo Charset= >> %workpath%\%filename%.dtf
echo ConvInd=0 >> %workpath%\%filename%.dtf
echo DateTimeLoc=0 >> %workpath%\%filename%.dtf
echo IncDateTime=0 >> %workpath%\%filename%.dtf
echo OverWrite=1 >> %workpath%\%filename%.dtf
echo RowAlignGenH=0 >> %workpath%\%filename%.dtf
echo RowAlignGenV=0 >> %workpath%\%filename%.dtf
echo RowAlignHdrH=0 >> %workpath%\%filename%.dtf
echo RowAlignHdrV=0 >> %workpath%\%filename%.dtf
echo RowStyleGen=1 >> %workpath%\%filename%.dtf
echo RowSytleHdr=1 >> %workpath%\%filename%.dtf
echo TabAlign=0 >> %workpath%\%filename%.dtf
echo TabBW=1 >> %workpath%\%filename%.dtf
echo TabCP=1 >> %workpath%\%filename%.dtf
echo TabCS=1 >> %workpath%\%filename%.dtf
echo TabCols=2 >> %workpath%\%filename%.dtf
echo TabMap=1 >> %workpath%\%filename%.dtf
echo TabRows=2 >> %workpath%\%filename%.dtf
echo TabWidth=100 >> %workpath%\%filename%.dtf
echo TabWidthP=0 >> %workpath%\%filename%.dtf
echo Template= >> %workpath%\%filename%.dtf
echo TemplateTag= >> %workpath%\%filename%.dtf
echo Title= >> %workpath%\%filename%.dtf
echo UseTemplate=0 >> %workpath%\%filename%.dtf
echo [Properties] >> %workpath%\%filename%.dtf
echo AutoClose=1 >> %workpath%\%filename%.dtf
echo AutoRun=1 >> %workpath%\%filename%.dtf
echo Check4Untrans=0 >> %workpath%\%filename%.dtf
echo Convert65535=0 >> %workpath%\%filename%.dtf
echo DisSysName=1 >> %workpath%\%filename%.dtf
echo DispLongSchemaName=1 >> %workpath%\%filename%.dtf
echo Notify=1 >> %workpath%\%filename%.dtf
echo SQLStmt=0 >> %workpath%\%filename%.dtf
echo ShowWarnings=0 >> %workpath%\%filename%.dtf
echo StoreDecFAsChar=1 >> %workpath%\%filename%.dtf
echo UseAlias=1 >> %workpath%\%filename%.dtf
echo UseCompression=1 >> %workpath%\%filename%.dtf
echo UseSSL=0 >> %workpath%\%filename%.dtf
echo UserOption=2 >> %workpath%\%filename%.dtf

:: read the file and call replace function
for /F "delims=" %%a IN (%hostfile%) do (call :replace %%a)

:: record end date/time
set "endtime=%date% %time%"

:: log start and end time
echo. >> %workpath%\%filename%.log && echo. >> %workpath%\%filename%.log && echo. >> %workpath%\%filename%.log
echo ################################################## >> %workpath%\%filename%.log
echo Script started at %starttime%. >> %workpath%\%filename%.log
echo Script completed at %endtime%. >> %workpath%\%filename%.log
echo ################################################## >> %workpath%\%filename%.log

:: perform cleanup
set COPYCMD=/Y
move /Y %workpath%\%filename%.log %backuppath%\%filename%.log > nul
move /Y %workpath%\%filename%.dtf %backuppath%\%filename%.dtf > nul
copy /Y %workpath%\%filename%.csv %backuppath%\%filename%.csv > nul

:: end the script
:end
GOTO :eof

:: peform the string replacement
:replace
set "string2=%1"
for /F "delims=" %%b in ('type "%workpath%\%filename%.dtf" ^& break ^> "%workpath%\%filename%.dtf"') do (
    set "line=%%b"
    setlocal enabledelayedexpansion
    set "line=!line:%string1%=%string2%!"
    >>"%workpath%\%filename%.dtf" echo(!line!
    endlocal
)

:: start downloading
rxferpcb.exe %workpath%\%filename%.dtf %userid% %password% >> %workpath%\%filename%.log
set "string1=%string2%"
GOTO :eof

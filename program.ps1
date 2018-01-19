<# ################################################################################################ #>
<# Script Repository URL: https://github.com/vivekjindal/as400-userid-expiry-report-automation      #>
<# ################################################################################################ #>


<# script configuration #>
$filename = "program"
$workpath = "x:\reports\$filename"
$smtpserver = ""
$fromemail = ""
$toemail = ""
$subject = "Report for internal 'ABCD' AS400 users expired or expiring in 15 days"
$string1 = "<td>YES</td>"
$string2 = "<td bgcolor=red>YES</td>"
$userid = ""
$password = ""
$callpgm = '"CALL PGM(QGPL/$filename)"'

<# call uidexpalrt pgm on all as400 lpars #>
$null > $workpath\$filename.logftp
Get-Content $workpath\hostfile.txt | ForEach-Object -Process {
    echo "open $_ 21" > $workpath/$filename.ftp
    echo $userid >> $workpath/$filename.ftp
    echo $password >> $workpath/$filename.ftp
    echo "quote rcmd $callpgm" >> $workpath/$filename.ftp
    echo bye >> $workpath/$filename.ftp
    ftp -i -s:$workpath/$filename.ftp >> $workpath\$filename.logftp
    echo "" "" >> $workpath\$filename.logftp
}

<# run the batch program #>
Start-Process -FilePath "cmd.exe" -ArgumentList "/C $filename.bat" -WorkingDirectory "$workpath" -Wait -WindowStyle "Hidden"

<# convert csv to html and do formatting #>
$import = Import-Csv -Path "$workpath\$filename.csv" -Delimiter "," -Encoding "ASCII"
$html = $import | Convertto-Html -As "Table"
$html = $html -replace $string1,$string2
$html > "$workpath\$filename.htm"

<# send email #>
Send-MailMessage -From "$fromemail" -To "$toemail" -Subject "$subject" -SmtpServer "$smtpserver" -Body "$html" -BodyAsHtml

<# perform cleanup #>
Move-Item -Path "$workpath\$filename.htm" -Destination "$workpath\backup\$filename.htm" -Force
Move-Item -Path "$workpath\$filename.csv" -Destination "$workpath\backup\$filename.csv" -Force
Move-Item -Path "$workpath\$filename.logftp" -Destination "$workpath\backup\$filename.logftp" -Force
Remove-Item -Path "$workpath\$filename.ftp" -Force -Confirm:$false

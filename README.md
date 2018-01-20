This repository contains multiple programs and scripts which are supposed to used altogether. PowerShell script is the parent which triggers the rest.

# Program Flow
PowerShell script triggers the CLLE PGM on AS400 hosts as defined in text file. CLLE PGM creates a SQL DB file containing list of expired users and users expiring in next 15 days. Only those users are selected that match the first 4 characters in user's text description as defined in CLLE PGM (Optional). CLLE PGM will also add a column for system's host name.

![IBM i Output](https://raw.githubusercontent.com/vivekjindal/as400-userid-expiry-report-automation/master/images/screenshot1.png)  

PowerShell script will then trigger the batch script. Batch script will download the SQL DB file from AS400 servers as defined in text file. The final output is a CSV file with combined data.

PowerShell script then converts CSV file into HTML and turns all cells 'red' that has expiry value as 'YES'. The final output is then sent via email as HTML body.  

![PowerShell Output](https://raw.githubusercontent.com/vivekjindal/as400-userid-expiry-report-automation/master/images/screenshot2.png)  

# Requirements

1. SMTP server access so that it can be used to send emails.
2. IBM i Access for Windows must be installed.
3. IBM i OS release 7.1 or greater. (CLLE PGM might work on older releases as well but I have not tested)
5. Windows with PowerShell installed.
6. FTP server must be running on AS400.

# Usage

1. A user database file must be required. So export users list in an outfile. Use below command:  
DSPUSRPRF USRPRF(\*ALL) OUTPUT(\*OUTFILE) OUTFILE(QGPL/USRPRFDB)
2. Create a table where CLLE PGM's output will be stored using the sql file provided in this repository.
4. Customize CLLE as per your needs, place it on AS400 servers and compile it. If you want all expired users and expiring within 15 days without any additional filtering criteria then comment lines 31, 32, 33 and recompile.
3. Place PowerShell script, batch script and text file on windows in same location. Customize the paths in scripts as per your preferences.
4. Add AS400 servers hostnames in text file and remove the dummy ones.
5. Run the PowerShell script.

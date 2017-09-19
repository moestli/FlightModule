$APIKeys    = Get-Content "$PSScriptRoot\my.apikey" | ConvertFrom-Json
$global:AmadeusKey = $APIKeys.AmadeusKey
$global:MapsKey    = $APIKeys.MapsKey

Get-ChildItem $PSScriptRoot\powershell -Filter *.ps1 | ForEach-Object {
    Import-Module $_.FullName
}
$APIKeys                = Get-Content "$PSScriptRoot\my.apikey" | ConvertFrom-Json
$global:AmadeusAirports = Get-Content "$PSScriptRoot\supportfiles\airports.json" | ConvertFrom-Json

$global:AmadeusKey = $APIKeys.AmadeusKey
$global:MapsKey    = $APIKeys.MapsKey

$global:FixerURL               = 'http://api.fixer.io/latest?base='
$global:AmadeusLowFareURL      = 'https://api.sandbox.amadeus.com/v1.2/flights/low-fare-search'
$global:AmadeausNearAirportURL = 'https://api.sandbox.amadeus.com/v1.2/airports/nearest-relevant'
$global:GMapsGeoCodeURL        = 'https://maps.googleapis.com/maps/api/geocode/json?address='

Get-ChildItem $PSScriptRoot\powershell -Filter *.ps1 | ForEach-Object {
    Import-Module $_.FullName
}
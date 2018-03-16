Function Get-NearestAirport {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]$Address
    )
    Begin {
        $Coordinates = Get-GoogleMapsCoordinate -Address $Address
        $Latitude    = $Coordinates.lat.ToString().split(',')[0]
        $Longitude   = $Coordinates.lng.ToString().split(',')[0]
        $URL = $AmadeausNearAirportURL
    }
    Process {
        $Parameters = @{'apikey'=$AmadeusKey;'latitude'=$Latitude;'longitude'=$Longitude}
        Invoke-RestMethod -Method Get -Uri $URL -Body $Parameters 
    }
}
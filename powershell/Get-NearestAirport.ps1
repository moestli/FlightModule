Function Get-NearestAirport {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]$Address
    )
    Begin {
        $Coordinates = Get-GoogleMapsCoordinate -Address $Address
        $Latitude    = $Coordinates.lat.ToString().split(',')[0]
        $Longitude   = $Coordinates.lng.ToString().split(',')[0]
        $URL = "https://api.sandbox.amadeus.com/v1.2/airports/nearest-relevant"
    }
    Process {
        $Parameters = @{'apikey'=$AmadeusKey;'latitude'=$Latitude;'longitude'=$Longitude}
        $Result = Invoke-RestMethod -Method Get -Uri $URL -Body $Parameters 
        $Result = $Result | Select-Object -Property airport,airport_name,city_name
    }
    End {
        return $Result
    }
}
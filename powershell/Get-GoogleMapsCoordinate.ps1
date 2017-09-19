Function Get-GoogleMapsCoordinate {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][string]$Address
    )
    Begin {
        $Address = $Address.Replace(' ','+')
        $URL = "https://maps.googleapis.com/maps/api/geocode/json?address=$Address&key=$MapsKey"
    }
    Process {
        $Result = (Invoke-RestMethod -Method Get -Uri $URL).results
    }
    End {
        return $Result.geometry.location
    }
}
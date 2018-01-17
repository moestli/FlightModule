Function Get-GoogleMapsCoordinate {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][string]$Address
    )
    Begin {
        $Address = $Address.Replace(' ','+')
        $URL = $GmapsGeoCodeURL + $Address + "&key=$MapsKey"
    }
    Process {
        $Result = (Invoke-RestMethod -Method Get -Uri $URL).results
    }
    End {
        return $Result.geometry.location
    }
}
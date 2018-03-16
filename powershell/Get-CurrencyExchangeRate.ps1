Function Get-CurrencyExchangeRate {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][string]$Currency,
        [Parameter(Mandatory)][string]$ReturnRate
    )
    Begin {
        $URL = $FixerURL + $Currency
    }
    Process {
       Invoke-RestMethod -Method Get -Uri $URL
    }
}
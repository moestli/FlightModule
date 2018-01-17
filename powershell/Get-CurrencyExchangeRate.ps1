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
        $Rates = Invoke-RestMethod -Method Get -Uri $URL | Select-Object -ExpandProperty Rates
    }
    End {
        return $Rates.$ReturnRate
    }
}
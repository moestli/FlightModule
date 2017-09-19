Function Get-CurrencyExchangeRate {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][string]$Currency,
        [Parameter(Mandatory)][string]$ReturnRate
    )
    Begin {
        $URL = "http://api.fixer.io/latest?base=$Currency"
    }
    Process {
        $Rates = (Invoke-RestMethod -Method Get -Uri $URL -UseBasicParsing).Rates
    }
    End {
        return $Rates.$ReturnRate
    }
}
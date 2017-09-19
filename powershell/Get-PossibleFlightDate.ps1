Function Get-PossibleFlightDate {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false)][string[]]$Months     = (Get-Date).Month,
        [Parameter(Mandatory=$false)][string[]]$Years      = (Get-Date).Year,
        [Parameter(Mandatory=$false)][int]$TripDuration    = 2,
        [Parameter(Mandatory=$false)][string]$DepartureDay = 'Friday'
    )
    Process {
        foreach ($Year in $Years) {
            foreach ($Month in $Months) {
                $Date = Get-Date -Month $Month -Date 1 -Year $Year 
                While ($Months -contains $Date.Month) {
                    if ($Date.DayOfWeek -eq $DepartureDay) {
                        $ReturnDate    = ($Date.AddDays($TripDuration)).ToString("yyyy-MM-dd")
                        $DepartureDate = $Date.ToString("yyyy-MM-dd")
                        New-Object -TypeName PSObject -Property @{'departure_date'=$DepartureDate;'return_date'=$ReturnDate}
                    }
                    $Date = $Date.AddDays(1)
                }
            }
        }
    }
}
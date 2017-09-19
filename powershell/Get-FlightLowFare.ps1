Function Get-FlightLowFare {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][string]$Origin,
        [Parameter(Mandatory)][string]$Destination,
        [Parameter(Mandatory)][string]$DepartureDate, # yyyy-MM-dd
        [Parameter(Mandatory=$false)][string]$ReturnCurrency = 'NOK'
    )
    Begin {
        [float]$CurrencyConversion = Get-CurrencyExchangeRate -Currency USD -ReturnRate $ReturnCurrency
        $URL  = "https://api.sandbox.amadeus.com/v1.2/flights/low-fare-search"
        $Body = @{'apikey'=$AmadeusKey;'origin'=$Origin;'destination'=$Destination;'departure_date'=$DepartureDate}  
    }
    Process {
        $Result = Invoke-RestMethod -Method Get -Uri $URL -Body $Body | Select-Object -ExpandProperty results
        $Result = $Result | ForEach-Object {
            $FlightFare  = $_.fare
            $Itineraries = $_.itineraries.outbound.flights
            foreach ($Itinerary in $Itineraries) {
                $FlightPrice  = [float]$FlightFare.total_price * $CurrencyConversion
                $FlightPrice  = [math]::Round($FlightPrice)
                $FlightNumber = $Itinerary.operating_airline + $Itinerary.flight_number
                $Aircraft     = $Itinerary.aircraft
                $FlightClass  = $Itinerary.booking_info.travel_class
                $FlightDate   = ($Itinerary.departs_at).split('T')[0]
                $FlightTime   = ($Itinerary.departs_at).split('T')[1]
                $ArrivalDate  = ($Itinerary.arrives_at).split('T')[0]
                $ArrivalTime  = ($Itinerary.arrives_at).split('T')[1]

                New-Object -TypeName psobject -Property @{
                    'price'          = $FlightPrice;
                    'flightNumber'   = $FlightNumber;
                    'aircraft'       = $Aircraft;
                    'class'          = $FlightClass;
                    'departure_date' = $FlightDate;
                    'departure_time' = $FlightTime;
                    'arrival_date'   = $ArrivalDate;
                    'arrival_time'   = $ArrivalTime
                }
            }
        }
    }
    End {
        return $Result
    }
}
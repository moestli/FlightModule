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
                $FlightDate   = Get-Date $Itinerary.departs_at -Format "dd.MM.yyyy"
                $FlightTime   = Get-Date $Itinerary.departs_at -Format "HH:mm"
                $ArrivalDate  = Get-Date $Itinerary.arrives_at -Format "dd.MM.yyyy"
                $ArrivalTime  = Get-Date $Itinerary.arrives_at -Format "HH:mm"
                $FlightDuration = New-TimeSpan -Start ($Itinerary.departs_at) -End ($Itinerary.arrives_at)

                New-Object -TypeName psobject -Property @{
                    'price'           = $FlightPrice;
                    'flightnumber'    = $FlightNumber;
                    'aircraft'        = $Aircraft;
                    'class'           = $FlightClass;
                    'departure_date'  = $FlightDate;
                    'departure_time'  = $FlightTime
                    'arrival_date'    = $ArrivalDate;
                    'arrival_time'    = $ArrivalTime
                    'flight_duration' = $FlightDuration 
                }
            }
        }
    }
    End {
        return $Result | Select-Object flightnumber,aircraft,class,departure_date,departure_time,arrival_date,arrival_time,flight_duration
    }
}
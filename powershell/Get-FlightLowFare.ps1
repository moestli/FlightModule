Function Get-FlightLowFare {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][string]$Origin,
        [Parameter(Mandatory)][string]$Destination,
        [Parameter(Mandatory=$false)][string]$ReturnCurrency = 'NOK',

        [Parameter(Mandatory,HelpMessage="Input must be in format yyyy-MM-dd")]
        [ValidateScript({[datetime]::ParseExact($_,'yyyy-MM-dd',$null)})]
        [string]$DepartureDate        
    )
    Begin {
        [float]$CurrencyConversion = Get-CurrencyExchangeRate -Currency USD -ReturnRate $ReturnCurrency | Select-Object -ExpandProperty Rates
        $Body = @{'apikey'=$AmadeusKey;'origin'=$Origin;'destination'=$Destination;'departure_date'=$DepartureDate}
        $Date = Get-Date -Format yyyy.MM.dd
    }
    Process {
        $Result = Invoke-RestMethod -Method Get -Uri $AmadeusLowFareURL -Body $Body | Select-Object -ExpandProperty results
        $Result | ForEach-Object {
            $FlightFare  = $_.fare
            $Itineraries = $_.itineraries.outbound.flights
            foreach ($Itinerary in $Itineraries) {

                New-Object -TypeName psobject -Property @{
                    'price'           = [math]::Round([float]$FlightFare.total_price * $CurrencyConversion);
                    'price_date'      = $Date;
                    'flightnumber'    = $Itinerary.operating_airline + $Itinerary.flight_number;
                    'aircraft'        = $Itinerary.aircraft;
                    'class'           = $Itinerary.booking_info.travel_class;
                    'departure_date'  = Get-Date $Itinerary.departs_at -Format "yyyy.MM.dd";
                    'departure_time'  = Get-Date $Itinerary.departs_at -Format "HH:mm";
                    'arrival_date'    = Get-Date $Itinerary.arrives_at -Format "yyyy.MM.dd";
                    'arrival_time'    = Get-Date $Itinerary.arrives_at -Format "HH:mm";
                    'flight_duration' = New-TimeSpan -Start ($Itinerary.departs_at) -End ($Itinerary.arrives_at)
                }
            }
        }
    }
}

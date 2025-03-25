class FlightTracker
  def initialize
    @aviation_api_key = ENV['AVIATION_API_KEY']
    @openai_client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
  end

  def fetch_flights(origin, destination)
    params = {
      key: @aviation_api_key,
      depIata: origin,
      arrIata: destination
    }

    response = HTTParty.get('https://aviation-edge.com/v2/public/flights', query: params)

    if response.success?
      process_flights(response.parsed_response)
    else
      []
    end
  end

  def process_flights(flights)
    flights.map do |flight|
      {
        flight_number: flight['flight']['iataNumber'],
        airline: flight['airline']['name'],
        departure: flight['departure']['scheduledTime'],
        arrival: flight['arrival']['scheduledTime'],
        price: generate_price
      }
    end
  end

  def enhance_with_ai(flights)
    return flights if flights.empty?

    prompt = "Analyze and provide insights for these flights: #{flights.to_json}"

    response = @openai_client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: prompt }]
      }
    )

    response.dig('choices', 0, 'message', 'content')
  end

  private

  def generate_price
    # Simple price generation logic
    "$#{rand(100..500)}"
  end
end

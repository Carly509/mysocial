require 'redis'

class FlightTracker
  def initialize
    @aviation_api_key = ENV['AVIATION_API_KEY']
    @openai_client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
    @redis = Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379/1')
  end

  def fetch_flights(origin, destination)
    cache_key = "flights:#{origin}:#{destination}"
    cached_data = @redis.get(cache_key)

    if cached_data
      return JSON.parse(cached_data)
    end

    params = {
      key: @aviation_api_key,
      depIata: origin,
      arrIata: destination
    }

    response = HTTParty.get('https://aviation-edge.com/v2/public/flights', query: params)

    if response.success?
      flights = process_flights(response.parsed_response)
      @redis.setex(cache_key, 3600, flights.to_json)
      flights
    else
      Rails.logger.error("API Error: #{response.code} - #{response.message}")
      raise "Failed to fetch flights: #{response.message}"
    end
  rescue HTTParty::Error => e
    Rails.logger.error("HTTParty Error: #{e.message}")
    []
  end

  def process_flights(flights)
    flights.map do |flight|
      {
        flight_number: flight['flight']['iataNumber'],
        airline: flight['airline']['name'],
        departure: flight['departure']['scheduledTime'],
        arrival: flight['arrival']['scheduledTime'],
        price: calculate_price(flight),
        distance: estimate_distance(flight)
      }
    end
  end

  def enhance_with_ai(flights)
    return "No flights available to analyze." if flights.empty?

    prompt = <<~PROMPT
      Given these flights: #{flights.to_json}, provide detailed recommendations.
      Consider factors like price, airline reputation, flight duration, and user preferences (e.g., cheapest, fastest).
      Return a JSON object with enhanced recommendations and insights.
    PROMPT

    response = @openai_client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: prompt }],
        response_format: { type: "json_object" }
      }
    )

    JSON.parse(response.dig('choices', 0, 'message', 'content')) rescue "AI enhancement failed."
  end

  private

  def calculate_price(flight)
    base_price = 100
    distance = estimate_distance(flight)
    duration = calculate_duration(flight)

    # Sophisticated pricing: $0.10 per mile + $20 per hour of flight
    price = base_price + (distance * 0.10) + (duration * 20)
    "$#{price.round(2)}"
  end

  def estimate_distance(flight)
    rand(500..5000)
  end

  def calculate_duration(flight)
    departure = Time.parse(flight['departure']['scheduledTime'])
    arrival = Time.parse(flight['arrival']['scheduledTime'])
    ((arrival - departure) / 3600.0).round(1)
  end
end

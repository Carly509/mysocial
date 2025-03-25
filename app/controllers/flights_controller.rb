class FlightsController < ApplicationController
  def index
    @recommendations = [
      {
        title: 'New York to Paris',
        price: '$300 Round Trip',
        image: 'https://cdn.usegalileo.ai/sdxl10/dad86ebf-f11b-4ef0-9080-e183749d8263.png'
      },
      {
        title: 'Los Angeles to New York',
        price: '$150 One Way',
        image: 'https://cdn.usegalileo.ai/sdxl10/fb503a98-e470-434d-be1b-b5ad9703a166.png'
      },
      # Add more recommendations
    ]
  end

  def search
    # Render search results page
  end

  def find_flights
    flight_tracker = FlightTracker.new


    origin = params[:origin]
    destination = params[:destination]

    @flights = flight_tracker.fetch_flights(origin, destination)

    # Optional: Use OpenAI to enhance flight recommendations
    @enhanced_recommendations = flight_tracker.enhance_with_ai(@flights)

    render :search
  end
end

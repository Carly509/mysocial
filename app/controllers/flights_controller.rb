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
      {
        title: 'San Francisco to Tokyo',
        price: '$600 Round Trip',
        image: 'https://cdn.usegalileo.ai/sdxl10/sample-tokyo-image.png'
      },
      {
        title: 'London to Sydney',
        price: '$900 Round Trip',
        image: 'https://cdn.usegalileo.ai/sdxl10/sample-sydney-image.png'
      }
    ]
  end

  def search
    # Render search results page
  end

  def find_flights
    flight_tracker = FlightTracker.new

    begin
      origin = params[:origin]
      destination = params[:destination]

      unless origin.present? && destination.present?
        flash[:error] = "Please provide both origin and destination."
        return render :search
      end

      @flights = flight_tracker.fetch_flights(origin, destination)
      @enhanced_recommendations = flight_tracker.enhance_with_ai(@flights)

      render :search
    rescue StandardError => e
      flash[:error] = "An error occurred while fetching flights: #{e.message}"
      render :search
    end
  end
end

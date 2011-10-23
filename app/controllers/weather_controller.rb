class WeatherController < ApplicationController
  def show
    get_weather(params[:place])
    freezing?(@low_today, @low_tomorrow)
  end
  
  private
  
    def get_weather(place)
      weather = Barometer.new(place).measure
      @low_today = weather.today.low.to_i
      @low_tomorrow = weather.tomorrow.low.to_i
    end
    
    def freezing?(today_temp, tomorrow_temp)
      if today_temp <= 32 or tomorrow_temp <= 32
        @answer = "Yes"
        true
      else
        @answer = "No"
        false    
      end
    end
    
end

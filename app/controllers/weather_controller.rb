class WeatherController < ApplicationController
  def show
    get_weather(params[:place])
    freezing?(@low_today, @low_tomorrow)
  rescue ArgumentError
    redirect_to :root, :alert => "The place you're looking for doesn't seem to exist. If you think that's a bug contact @JasonCarpentier"
  end
  
  def mobile
    @twilio_client = Twilio::REST::Client.new(twilio_account_sid, twilio_auth_token)
    get_weather(params['Body'])
    @twilio_client.account.sms.messages.create(:from => '+12106512991', :to => params['From'],:body => @msg)
  end

  private
  
    def get_weather(place)
      weather = Barometer.new(place).measure
      @low_today = weather.today.low.to_i
      @low_tomorrow = weather.tomorrow.low.to_i
      @location_city = weather.default.location.city
      @location_state_code = weather.default.location.state_code
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

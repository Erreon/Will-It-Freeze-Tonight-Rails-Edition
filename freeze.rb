require 'rubygems'
require 'sinatra'
require 'sinatra/flash'
require 'barometer'
require 'erb'
require 'twilio-ruby'
require 'uri'

enable :sessions
API_VERSION = '2010-04-01'
account_sid = 'ACb1ab811f67f385bc1e663b1d70f18b9a'
auth_token = '10e2c8613d42b83211b4a91eff98f45e'

helpers do
  def freezing?(temp)
    if temp <= 32
      true
    else
      false
    end
  end

  def get_weather(place)
    barometer = Barometer.new(place)
    weather = barometer.measure
    @today_low_f = weather.today.low.to_i
    @tomorrow_low_f = weather.today.low.to_i
    @location = weather.default.location.city
  end

end

get '/' do
  @title = "WillItFreezeTonight.com"
  erb :index
end

post '/mobile' do
  @twilio_client = Twilio::REST::Client.new(account_sid, auth_token)
  get_weather(params['Body'])
  if freezing?(@today_low_f)

  else
    msg = "No, Today's low in #{@location} is: #{@today_low_f}F and Tomorrow's low is: #{@tomorrow_low_f}F"
  end

  @twilio_client.account.sms.messages.create(:from => '+12106512991', :to => params['From'],:body => @msg)
end

get '/:place' do
  begin
    place = params[:place]
    barometer = Barometer.new(place)
    weather = barometer.measure
    @today_low_f = weather.today.low.to_i
    @today_low_c = (@today_low_f - 32) * 5/9
    @tomorrow_low_f = weather.tomorrow.low.to_i
    @tomorrow_low_c = (@tomorrow_low_f - 32) * 5/9
    @location = weather.default.location.city
    @site = URI.escape("http://willitfreezetonight.com/#{@location}")
  rescue ArguementError
    flash["alert-message error"] = "Either this place doesn't exist or we don't have access to weather info there.  Try searching for a nearby town or zipcode. <br /> Contact me @JasonCarpentier to report"
  end
  erb :weather
end

post '/weather' do
  begin
    place = params[:query]
    barometer = Barometer.new(place)
    weather = barometer.measure
    @today_low_f = weather.today.low.to_i
    @today_low_c = (@today_low_f - 32) * 5/9
    @tomorrow_low_f = weather.tomorrow.low.to_i
    @tomorrow_low_c = (@tomorrow_low_f - 32) * 5/9
    @location = weather.default.location.city
    @site = URI.escape("http://willitfreezetonight.com/#{@location}")
    rescue ArgumentError
      if place.downcase == "hell"
        @hell = "Probably not, but if the Cowboys won today... Yes and there is snow too!"
      else
        flash["alert-message error"] = "Either this place doesn't exist or we don't have access to weather info there.  Try searching for a nearby town or zipcode. <br /> Contact me @JasonCarpentier to suggest a place."
        redirect '/'
      end
  end
  erb :weather
end

not_found do
  redirect '/'
end

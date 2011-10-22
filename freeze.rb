require 'rubygems'
require 'sinatra'
require 'sinatra/flash'
require 'barometer'
require 'erb'
require 'uri'

enable :sessions

helpers do
  def check_weather(place)
    begin
      barometer = Barometer.new(place)
      weather = barometer.measure
      @today_low_f = weather.today.low.to_i
      @today_low_c = (@today_low_f - 32) * 5/9
      @tomorrow_low_f = weather.tomorrow.low.to_i
      @tomorrow_low_c = (@tomorrow_low_f - 32) * 5/9
      @location = weather.default.location.city
      @site = URI.escape("http://willitfreezetonight.com/#{@location}")
    rescue ArgumentError
      flash["alert-message error"] = "Either this place doesn't exist or we don't have access to weather info there.  Try searching for a nearby town or zipcode. <br /> Contact me @JasonCarpentier to report any issues."
      redirect '/'
    end
  end
  def freezing?(temp)
    if temp <= 32
      true
    else 
      false
    end
  end
end

get '/' do
  @title = "WillItFreezeTonight.com"
  erb :index
end

get '/:place' do
  check_weather(params[:place])
  erb :weather
end

post '/weather' do
  check_weather(params[:query])
  erb :weather
end
not_found do
  redirect '/'
end

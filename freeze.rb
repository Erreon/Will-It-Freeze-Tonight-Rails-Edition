require 'rubygems'
require 'sinatra'
require 'sinatra/flash'
require 'barometer'
require 'erb'

enable :sessions

helpers do
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

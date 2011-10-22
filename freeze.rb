require 'rubygems'
require 'sinatra'
require 'sinatra/flash'
require 'barometer'
require 'erb'
require 'twilio-ruby'

enable :sessions

@account_sid = 'ACb1ab811f67f385bc1e663b1d70f18b9a'
@auth_token = '10e2c8613d42b83211b4a91eff98f45e'
@twilio_client = Twilio::REST::Client.new(@account_sid, @auth_token)

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

post '/mobile' do
  print 'test'
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
        flash[:warning] = "Either this place doesn't exist or we don't have access to weather info there.  Try searching for a nearby town or zipcode. Contact me @JasonCarpentier to suggest a place."
        redirect '/'
      end
  end
  erb :weather
end

not_found do
  redirect '/'
end

require 'dotenv'
require 'sinatra'
require 'httparty'
require 'wunderlist'
require 'json'

Dotenv.load

set :bind, '0.0.0.0'

wunderlist = Wunderlist::API.new({
  access_token: ENV['ACCESS_TOKEN'],
  client_id: ENV['CLIENT_ID']
})

def item_search(upc)
  HTTParty.get("http://api.upcdatabase.org/json/#{ENV['UPC_ID']}/#{upc}")
end

get '/' do
  "Hello"
end

get '/item' do
  upc = params[:upc]

  item = item_search(upc)

  if item['valid'] == "true"
    task = wunderlist.new_task('Grocery List', {title: item['itemname'], completed: false})
    task.save
    "#{item['itemname']} saved!"
  else
    item['reason']
  end
end
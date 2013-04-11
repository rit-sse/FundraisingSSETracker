require 'sinatra/base'
require 'pg'
require '../DatabaseModels'

class Site < Sinatra::Base

	#pages
	get '/' do
		erb :index
	end

  get '/percent-purchased' do
    @items = Item.all
    erb :percent_purchased
  end
end

Site.run! if $0 == __FILE__
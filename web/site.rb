require 'sinatra/base'
require 'pg'
require '../DatabaseModels'



class Site < Sinatra::Base
  use Rack::Deflater
  use ActiveRecord::ConnectionAdapters::ConnectionManagement
	#pages
	get '/' do
		erb :index
	end

  get '/percent-purchased' do
    @items = Item.all
    erb :percent_purchased
  end

  after do
    ActiveRecord::Base.connection.close
  end
end

Site.run! if $0 == __FILE__
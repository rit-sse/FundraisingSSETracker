require 'sinatra/base'
require '../DatabaseModels'
require './helper'



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

  get '/percent-purchased-data' do
    @items = Item.all
    @data_shown = params[:data_shown]
    erb :"percent-purchased-data", layout: false
  end

  get '/net-profit' do
    @scans = Scan.all
    erb :"net-profit"
  end

   get '/net-profit-data' do
    @scans = Scan.all
    erb :"net-profit-data", layout: false
  end


  after do
    ActiveRecord::Base.connection.close
  end
end

Site.run! if $0 == __FILE__
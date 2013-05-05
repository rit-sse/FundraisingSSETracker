require 'sinatra/base'
require 'will_paginate'
require 'will_paginate/active_record'
require 'will_paginate/view_helpers/sinatra'
require 'will_paginate-bootstrap'
require '../DatabaseModels'
require './helper'



class Site < Sinatra::Base
  use Rack::Deflater
  use ActiveRecord::ConnectionAdapters::ConnectionManagement

  helpers WillPaginate::Sinatra::Helpers
	#pages
	get '/' do
		erb :index
	end

  get '/percent-purchased' do
    @items = Item.paginate(page: params[:page], per_page: 8)
    erb :percent_purchased
  end

  get '/percent-purchased-data' do
    @items = Item.paginate(page: params[:page], per_page: 8)
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
require 'sinatra/base'
require 'pg'

class Site < Sinatra::Base

	#pages
	get '/' do
		erb :index
	end
end

Site.run! if $0 == __FILE__
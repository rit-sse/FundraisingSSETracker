require './FoodItem.rb'
require 'pg'

class FoodSaver

	def initialize
		@conn = PG.connect(:dbname => 'fundraising')
	end

	def save_item(item)
		raise "oh no" if not item.kind_of? FoodItem
		
		begin
			@conn.prepare('statement', 'insert into items (upc, name, cost, retail_price) values ($1, $2, $3, $4);')
			@conn.exec_prepared('statement', [item.upc, item.name, 0.25, 0.5])
		rescue Exception => ex
			puts "oh no database problem time to panic (#{ex.message})"
		end
	end


	def load_item
		loaded = Hash.new
		begin
			res = @conn.exec('select * from items;')
			
			res.each do |item|
				upc = item["upc"]
				loaded[upc] = FoodItem.new(upc, 1, item["name"])
			end

		rescue Exception => ex
			puts "oh no database problem time to panic (#{ex.message})"
		end

		loaded
	end

	def close
		@conn.close if not @conn.nil?
	end

end
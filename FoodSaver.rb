require './FoodItem.rb'
require 'pg'

class FoodSaver

	def initialize
		#start connection
		@conn = PG.connect(:dbname => 'fundraising')

		#prepare statements
		@conn.prepare('insert_in_items', 'insert into items (upc, name, cost, retail_price) values ($1, $2, $3, $4);')
		@conn.prepare('insert_in_inventory', 'insert into inventory (item_upc, amount) values ($1, $2);')
		@conn.prepare('update_inventory', 'update inventory set amount = $1 where item_upc=$2;')
		@conn.prepare('insert_timestamp', 'insert into scans (item_upc, time) values ($1, $2);')
	end

	def save_new_item(item)
		raise "oh no" if not item.kind_of? FoodItem
		
		begin
			# insert into items table
			@conn.exec_prepared('insert_in_items', [item.upc, item.name, 0.25, 0.5])

			# create row in inventory table
			@conn.exec_prepared('insert_in_inventory', [item.upc, 1])
		rescue Exception => ex
			puts "oh no database problem time to panic (#{ex.message})"
		end
	end

	def update_item_amount(upc, amount)
		begin
			@conn.exec_prepared('update_inventory', [amount, upc])
		rescue Exception => ex
			puts "oh no database problem time to panic (#{ex.message})"
		end
	end

	def add_scan_timestamp(upc, time)
		begin
			@conn.exec_prepared('insert_timestamp', [upc, time])
		rescue Exception => ex
			puts "oh no database problem time to panic (#{ex.message})"
		end
	end

	def load_item
		loaded = Hash.new
		begin
			res = @conn.exec('select * from items, inventory where items.upc = inventory.item_upc;')
			
			res.each do |item|
				upc = item["upc"]
				loaded[upc] = FoodItem.new(upc, item["amount"], item["name"])
			end

		rescue Exception => ex
			puts "oh no database problem time to panic (#{ex.message})"
		end

		loaded
	end

	def load_scans
		loaded = Hash.new

		begin
			res = @conn.exec('select * from scans;')
			
			res.each do |item|
				upc = item["item_upc"]
				loaded[upc] = Array.new if not loaded.has_key? upc
				loaded[upc].push item["time"]
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
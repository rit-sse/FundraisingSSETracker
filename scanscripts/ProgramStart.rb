# Initiation file for the Food Inventory Tracker

require './FoodTracker.rb'
require './FoodSaver.rb'
require './FoodItem.rb'

begin
	item = Scans.create(:item_upc => "123123", :time => DateTime.now, :purchase => false, :quantity => 1) 
	food = Item.create(:upc=>"232323", :name=>"asdf", :cost=>"0.4", :retail_price=>"0.5")

	#@saver = FoodSaver.new
	#ft = FoodTracker.new(nil)
	#ft.command_line
ensure
	#@saver.close if not @saver.nil?
end
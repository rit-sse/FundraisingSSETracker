# Initiation file for the Food Inventory Tracker

require './FoodTracker.rb'
require './FoodSaver.rb'

begin
	@saver = FoodSaver.new
	ft = FoodTracker.new(@saver)
	ft.command_line
ensure
	@saver.close if not @saver.nil?
end
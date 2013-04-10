require 'open-uri'
require 'Nokogiri'


class FoodParser
	# Calls upcdatabase.com and gets the HTML of the item's upc page.
	# then searches for the "Description" td and grabs the items corresponding description
	# that is usually the name
	def get(upc)
		result = Nokogiri::HTML(open("http://www.upcdatabase.com/item/" + upc)).at('td:contains("Description")')
		#for some reason theres a blank td after description
		result.nil? ? alt_name : result.next.next.text
	end
	
	def alt_name
		puts("[SYSTEM] Invalid item in database")
		print("alternative item name, [enter] for \"Invalid\"\n>>")
		gets.chomp
	end
end
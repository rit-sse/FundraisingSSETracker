require './FoodItem.rb'

class FoodTracker

  def initialize()
    @table = Hash.new()
  end

  def command_line()
    instructions = "(n)ew , (a)dd, (r)ead, (q)uit\nput in a hash to remove one element of it, or add a new item to store it in the database.\n"
    puts(instructions)
    input = gets.chomp
    puts()
    while(input != "q")
      if input == "a"
        add_item_cmd
      elsif input == "r"
        read_items
      elsif input == "n"
        new_item
      else
        if @table.has_key?(input)
          @table[input].sub()
        else
          new_item(input)
        end
      end
      puts()
      puts(instructions)
      input = gets.chomp
    end
  end

  def new_item(upc=gets.chomp)
    @table[upc] = FoodItem.new(upc, 0)
  end

  def add_item_cmd
    puts("item: ")
    item = gets.chomp
    puts("number: ")
    number = gets.chomp.to_i
    add_item(@table[item],number)
  end
  def add_item(item, number)
    item.add(number)
  end
  def remove_item(item)
    item.sub()
  end
  def read_items()
    @table.each {|key,value| puts value}
  end
end
require './FoodItem.rb'

class FoodTracker

  def initialize
    @table = Hash.new
  end

  def command_line
    instructions = "(n)ew , (a)dd, (r)ead, (q)uit\nput in a hash to remove one element of it, or add a new item to store it in the database.\n"
    puts(instructions)
    while((input = gets.chomp) != "q")
      if input == "a"
        add_item_cmd
      elsif input == "r"
        read_items_cmd
      elsif input == "n"
        new_item_cmd
      else
        if @table.has_key?(input)
          @table[input].add_item
        else
          new_item(input)
        end
      end
      puts(instructions)
    end
  end

  def new_item_cmd(upc=gets.chomp)
    @table[upc] = FoodItem.new(upc,0)
  end

  def add_item_cmd
    puts("item: ")
    item = gets.chomp
    puts("number: ")
    number = gets.chomp.to_i
    add_item(@table[item],number)
  end
  
  def add_item(item, number=1)
    item.add(number)
  end
  
  def remove_item(item)
    item.add(-1)
  end
  
  def read_items_cmd
    @table.each {|key,value| puts value}
  end
end
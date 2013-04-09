require './FoodItem.rb'
require './FoodSaver.rb'

# The Food Tracker Class is the CLI interface
# which holds a Hash Table.
# The hash table called @table is the data structure
# to hold the FoodItem objec and a count of that FootItem
class FoodTracker

  def initialize
    @table = Hash.new
    @saver = FoodSaver.new

    sysout("Loading Food...")
    @table = @saver.load_item

    sysout("Starting Food Tracker")
  end

  def command_line
    prompt = "(n)ew , (a)dd, (r)ead, (q)uit\nput in a hash to remove one element of it, or add a new item to store it in the database.\n"
    while(true) do
      puts
      sysout( prompt )
      print ">> "

      input = gets.chomp
      abort("EOF, terminating program...") if input == nil
      input.downcase!

      case input
      when "a"
        add_item_cmd
      when "r"
        read_items
      when "n"
        new_item
      when "q"
        shutdown
      else
        new_item(input)
      end
    end
  end

  def new_item(upc=gets.chomp)
    if not @table.has_key?(upc)
      @table[upc] = FoodItem.new(upc,1)
      @saver.save_item(@table[upc])
    else
      @table[upc].add
    end

    

  end

  # Add any number of items
  def add_item_cmd
    puts("item: ")
    item = gets.chomp
    puts("number: ")
    number = gets.chomp.to_i
    add_item(@table[item],number)
  end

  # Add Item
  def add_item(item, number=1)
    item.add(number)
  end

  # Read items
  def read_items
    @table.each {|key,value| puts value}
  end

  # System IO for future debugging
  def sysout(string)
    puts ("[SYSTEM]: " + string)
  end

  # Shutdown sequence when cli recieves 'q'
  def shutdown
    sysout("System going for shutdown")
    #Do I/O (save to file for example)
    abort("Food Item Tracker Terminated")
  end
end

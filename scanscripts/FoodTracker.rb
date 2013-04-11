require './FoodItem'
require './FoodParser'
require './FoodConfig'

# The Food Tracker Class is the CLI interface
# which holds a Hash Table of FoodItems.
class FoodTracker

  def initialize()
    @config = FoodConfig.new
    @purchase_mode = true

    sysout("Starting Food Tracker")
  end

  def command_line
    prompt = "(n)ew , (a)dd, (r)ead, (p)urchase mode toggle, (v)iew scan times, (q)uit \nput in a hash to remove one element of it, or add a new item to store it in the database.\n"
    while(true) do
      puts
      sysout( prompt )
      print ">> "

      input = gets.chomp
      input = @config.get_upc(input) #filter for redirects
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
      when "v"
        list_scans
      when "p"
        @purchase_mode = !@purchase_mode
        sysout("Purchase mode #{@purchase_mode ? "on" : "off"}")
      else
        new_item(input)
      end
    end
  end

  #list all the valid scans made by item
  def list_scans
    Item.scoped.each {|i|
      puts i.name
      i.scans.each {|x| puts "\t#{x}"}
      puts ""
    }
  end

  def new_item(upc=gets.chomp, number=1)
    upc = @config.get_upc(upc)
    scan_time = DateTime.now

    # break down variety packs
    if @config.variety_packs.has_key?(upc)
      @config.variety_packs[upc].each do |item, amount|
        new_item(item, number*amount)
      end
    else
      item = Item.find_by_upc(upc)
      if not @purchase_mode
        puts "fundraising is stocking the cabinet"

        if not item #create new food if it doesnt exist already
          item = Item.create(:upc=>upc, :name=>FoodParser.new.get(upc), :cost=>0, :retail_price=>0)
        end
        record_scan_time(item.id, scan_time, number)
      else
        if not item
          puts "This item is not in the database. Please contact fundraising@sse.se.rit.edu before buying the item."
        else
          record_scan_time(item.id, scan_time, number)
        end
      end
    end
  end

  def record_scan_time(id, time, number)
    Scan.create(:item_id=>id, :time=>time, :purchase=>@purchase_mode, :quantity=>number)
  end

  # Add any number of items
  def add_item_cmd
    puts("upc: ")
    upc = gets.chomp
    puts("number: ")
    number = gets.chomp.to_i
    new_item(upc, number)
  end

  # Add Item
  def add_item(upc, number=1)

    # save the item to the database
    @table[upc].add(number, @purchase_mode)
    num = @purchase_mode ? @table[upc].sold : @table[upc].stock
    #@saver.update_item_amount(@table[upc].upc, num, @purchase_mode)
  end

  # Read items
  def read_items
    Item.scoped.each {|x| puts x}
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

require File.join(File.dirname(__FILE__),'..', 'DatabaseModels')
require File.join(File.dirname(__FILE__),'FoodParser')
require File.join(File.dirname(__FILE__),'FoodConfig')

# The Food Tracker Class is the CLI interface
# which holds a Hash Table of FoodItems.
class FoodTracker

  def initialize()
    @config = FoodConfig.new
    @purchase_mode = true

    sysout("Starting Food Tracker")
  end

  def command_line
    prompt = "(a)dd, (e)dit, (r)ead, (p)urchase mode toggle, (v)iew scan times, (q)uit \nput in a hash to remove one element of it, or add a new item to store it in the database.\n"
    while(true) do
      puts
      sysout( prompt )
      print ">> "

      input = gets.chomp
      input = @config.get_upc(input) #filter for redirects
      abort("EOF, terminating program...") if input.nil?
      input.downcase!

      case input
      when "a"
        add_item_cmd
      when "e"
        edit_item
      when "r"
        read_items
      when "q"
        shutdown
        break
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
      item = Item.find_by_upc(upc.downcase)
      puts item
      if not @purchase_mode
        puts "fundraising is stocking the cabinet"
        if not item #create new food if it doesnt exist already
          item = @config.dummy[upc]
          name =  item.nil? ? FoodParser::get(upc) : item[:name]
          name.gsub!(/"/,'')
          puts("#{name}'s cost: ")
          cost = gets.chomp.to_f
          puts("#{name}'s retail price: ")
          retail_price = gets.chomp.to_f
          item = Item.create(upc: upc, name: name, cost: cost, retail_price: retail_price)
        end
        update_item_amount(item, number)
        record_scan_time(item, scan_time, number)
      else
        if not item
          puts "This item is not in the database. Please contact fundraising@sse.se.rit.edu before buying the item."
        else
          inventory = item.inventory
          if (inventory.amount - inventory.sold > 0)
            record_scan_time(item, scan_time, number)
            update_item_amount(item, number)
          else
            puts "Inventory is out of sync - please contact fundraising@sse.se.rit.edu"
          end
        end
      end
    end
  end

  def record_scan_time(item, time, number)
    scan = Scan.new(time: time, purchase: @purchase_mode, quantity: number)
    scan.item = item
    scan.save
  end

  # Add any number of items
  def add_item_cmd
    puts("upc: ")
    upc = gets.chomp
    puts("number: ")
    number = gets.chomp.to_i
    new_item(upc, number)
  end

  def update_item_amount(item, amount)
    inventory = item.inventory.nil? ? Inventory.create(amount: 0, sold: 0){|i| i.item = item } : item.inventory

    if @purchase_mode
      Inventory.update(inventory.id, :sold=>"#{inventory.sold + amount}")
    else
      Inventory.update(inventory.id, :amount=>"#{inventory.amount + amount}")
    end
  end

  # Read items
  def read_items
    Item.scoped.each {|x| puts "#{x}\t(#{x.inventory.amount - x.inventory.sold} remaining)"}
  end

  def edit_item
    puts("UPC to edit: ")
    upc = gets.chomp
    upc = @config.get_upc(upc)
    item = Item.find_by_upc(upc)
    if item.nil?
      sysout("Item not in database")
    else
      while(true)
        sysout("Editing #{item.name}.")
        sysout("What would you like to edit? (n)ame, (r)etail price, (c)ost, (b)ack")
        input = gets.chomp
        case input
        when 'n'
          puts "New name:"
          item.name = gets.chomp
          item.save
        when 'r'
          puts "New retail price:"
          item.retail_price = gets.chomp
          item.save
        when 'c'
          puts "New cost:"
          item.cost = gets.chomp
          item.save
        when 'b'
          break
        else
          puts 'Invalid Option'
        end
      end
    end
  end

  # System IO for future debugging
  def sysout(string)
    puts ("[SYSTEM]: " + string)
  end

  # Shutdown sequence when cli recieves 'q'
  def shutdown
    sysout("System going for shutdown")
    #Do I/O (save to file for example)
    puts("Food Item Tracker Terminated")
  end

end

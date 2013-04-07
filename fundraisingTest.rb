class FoodItem
  def initialize(hash, number)
    system("wget -q www.upcdatabase.com/item/#{hash}")
    file = File.open(hash)
    contents = file.read()
    if !(contents.include? "Description")
      @name = "invalid"
    else
      @name = contents.split("<tr><td>Description</td><td></td><td>")[1].split("</td>")[0]
    end
    @UPC = hash
    @number = number
    system("rm #{hash}")
  end

  def add(value=1)
    @number = @number + value
  end

  def sub()
    @number = @number - 1
  end

  def to_s()
    "#{@number}\t\"#{@name}\" (#{@UPC})"
  end
end

class FoodDatabase

  def initialize()
    @table = Hash.new()
  end

  def commandLine()
    puts("(n)ew , (a)dd, (r)ead, (q)uit\nput in a hash to remove one element of it, or add a new item to store it in the database.\n")
    input = gets.chomp
    puts()
    while(input != "q")
      if input == "a"
        addLine
      elsif input == "r"
        readItems
      elsif input == "n"
        newItem
      else
        if @table.has_key?(input)
          @table[input].sub()
        else
          newItem(input)
        end
      end
      puts()
      puts("(n)ew , (a)dd, (r)ead,\nput in a hash to remove one element of it.\n(q)uit")
      input = gets.chomp
    end
  end

  def newItem(upc=gets.chomp)
    @table[upc] = FoodItem.new(upc, 0)
  end

  def addLine()
    puts("item: ")
    item = gets.chomp
    puts("number: ")
    number = gets.chomp.to_i
    addItem(@table[item],number)
  end
  def addItem(item, number)
    item.add(number)
  end
  def removeItem(item)
    item.sub()
  end
  def readItems()
    @table.each {|key,value| puts value}
  end
end

fd = FoodDatabase.new()
fd.commandLine()

require './FoodParser.rb'

class FoodItem
  def initialize(upc, stock, sold, name=nil)
    if name.nil?
      # correct for parity bit
      #upc = upc_parity_fix(upc) if upc.length == 7
      @name = FoodParser.new.get(upc)
    else
      @name = name
    end

    @stock = stock.to_i
    @sold = sold.to_i
    @upc = upc
  end

  attr_reader :upc, :stock, :sold, :name

  def add(value=1,sales=false)
    sales ? @sold += value : @stock += value
  end

  def upc_parity_fix(upc)
    str_dec = ""
    upc + str_dec
  end

  def to_s
    "#{@sold}/#{@stock}\t\"#{@name}\" (#{@upc})"
  end

end

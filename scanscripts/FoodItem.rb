require './FoodParser.rb'

class FoodItem


  def initialize(upc, number, name=nil)
    if name.nil?
      # correct for parity bit
      #upc = upc_parity_fix(upc) if upc.length == 7
      @name = FoodParser.new.get(upc)  
    else
      @name = name
    end

    @number = number.to_i
    @upc = upc
  end

  attr_reader :upc, :number, :name

  def add(value=1)
    @number += value
  end

  def upc_parity_fix(upc)
    str_dec = ""
    upc + str_dec
  end

  def to_s
    "#{@number}\t\"#{@name}\" (#{@upc})"
  end

end

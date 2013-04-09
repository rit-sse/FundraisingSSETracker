require './FoodParser.rb'

class FoodItem


  def initialize(upc, number, name=nil)
    if name.nil?
      # correct for parity bit
      upc = upc_parity_fix(upc) if upc.length == 7

      x = FoodParser.new
      @name = x.get(upc)
      @number = number
      @upc = upc
    else
      @name = name
      @number = number
      @upc = upc
    end
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

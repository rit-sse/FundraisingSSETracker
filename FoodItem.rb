require './FoodParser.rb'

class FoodItem
  def initialize(hash, number)
    # correct for parity bit
    hash = upc_parity_fix(hash) if hash.length == 7

    x = FoodParser.new
    @name = x.get(hash)
    @number = number
    @upc = hash
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

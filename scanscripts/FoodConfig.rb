class FoodConfig

  def initialize
    init_variety
    init_redirect
  end

  attr_accessor :variety_packs

  def init_variety
    @variety_packs = Hash.new
    pointer = ''

    File.open('./configs/variety.config').each do |line|
      if line =~ /^[#\n]/
        #do nothing
      elsif line =~ /^[0-9]/
        # grab all digits of the variety box and create a hash for its contents
        pointer = line.gsub(/\D/, '')
        @variety_packs[pointer] = Hash.new
      elsif line =~ /^[\-]/
        #Adds upc and quanity to the variety pack
        quantity = line.gsub(/-/, '').split
        @variety_packs[pointer][quantity[0]] = quantity[1].to_i
      end
    end
  end

  def init_redirect
    #JESSE CODE
  end
end
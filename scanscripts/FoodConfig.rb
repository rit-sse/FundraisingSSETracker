class FoodConfig

  def initialize
    init_variety
    init_redirect
  end

  def init_variety
    @variety_packs = Hash.new
    pointer = ''

    File.open('./configs/variety.config').each do |line|
      if line =~ /^[#\n]/
        #do nothing
      elsif line =~ /^[0-9]/
        # grab all digits and store in filter
        pointer = line.gsub(/\D/, '')
        @variety_packs[pointer] = Hash.new
      elsif line =~ /^[\-]/
        quantity = line.gsub(/-/, '').split
        @variety_packs[pointer][quantity[0]] = quantity[1]
      end
    end
  end

  def init_redirect
    #JESSE CODE
  end
end
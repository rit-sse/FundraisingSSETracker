class FoodConfig

  def initialize
    init_variety
    @variety_packs.each_key do |pack|
      check_variety pack
    end
    init_redirect
    init_dummy
  end

  attr_accessor :variety_packs, :dummy

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
    @redirect= Hash.new
    pointer = ""
    File.open('./configs/redirect.config').each do |line|
      if line =~ /^[#\n]/
        #do nothing
      elsif line =~ /^[0-9]/
        # grab all digits and store in filter
        pointer = line.gsub(/\D/, '')
      elsif line =~ /^[\-]/
        # grab all digits and store in hash, redirecting to pointer
        @redirect[line.gsub(/\D/, '')] = pointer.gsub(/\D/, '')
      end
    end
  end

  def init_dummy
    @dummy= Hash.new
    File.open('./configs/dummy.config').each do |line|
      line_split = line.split(/,/)
      @dummy[line_split[0]] = {name:line_split[1], price:line_split[2]}
    end
  end

  def check_variety pack, array=Array.new
    @variety_packs[pack].each_key do |item|
      abort('Your config is bad and you should feel bad.') if array.include?(item)
      if @variety_packs.has_key?(item)
        array << item
        check_variety item, array
      end
    end
  end

  # returns either the original upc,
  # or returns a new upc if found in our config
  def get_upc(upc)
    @redirect.has_key?(upc) ? @redirect[upc] : upc
  end

end
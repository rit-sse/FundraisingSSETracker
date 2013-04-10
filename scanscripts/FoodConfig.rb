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

  def check_variety pack, array=Array.new
    @variety_packs[pack].each_key do |item|
      raise 'Your config is bad and you should feel bad' if array.include?(item)
      if @variety_packs.has_key?(item)
        array << item
        check_variety item, array
      end
    end
  end

  # returns either the original upc,
  # or returns a new upc if found in our config
  def get_upc(upc)
    if @redirect.has_key?(upc)
      return @redirect[upc]
    end

    return upc
  end

end
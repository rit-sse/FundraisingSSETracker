class FoodFilter

  # class for filtering upc codes to be generic
  # based on the filter.config file, or a given config file
  def initialize(filterFile="./filter.config")
    @redirect= Hash.new
    pointer = ""
    File.open(filterFile).each do |line|
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
    
  # returns either the original upc,
  # or returns a new upc if found in our config
  def get_upc(upc)
    if @redirect.has_key?(upc)
      return @redirect[upc]
    end

    return upc
  end

end

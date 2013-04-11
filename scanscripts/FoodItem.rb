require '../DatabaseConfiguration.rb'

class Item < ActiveRecord::Base
  attr_accessible :upc, :name, :cost, :retail_price
  has_many :scans
  has_one :inventory

  def to_s
    "#{name} (#{upc})"
  end
end 

class Scan < ActiveRecord::Base
  attr_accessible :item_id, :time, :purchase, :quantity

  def to_s
   "#{time}\t#{quantity} items (#{purchase ? "sale" : "inventory stock"})"
  end
end

class Inventory < ActiveRecord::Base
  attr_accessible :item_id, :amount, :sold
end


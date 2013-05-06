require '../DatabaseConfiguration'

class Item < ActiveRecord::Base
  attr_accessible :upc, :name, :cost, :retail_price
  has_many :scans
  has_one :inventory

  validates :cost, :retail_price, numericality: true

  def to_s
    "#{name} (#{upc})"
  end
end

class Scan < ActiveRecord::Base
  attr_accessible :time, :purchase, :quantity
  belongs_to :item

  validates :quantity, numericality: {only_integer: true}
  def to_s
   "#{time}\t#{quantity} items (#{purchase ? "sale" : "inventory stock"})"
  end
end

class Inventory < ActiveRecord::Base
  attr_accessible :amount, :sold
  belongs_to :item

  validates :amount, :sold, numericality: {only_integer: true}
end


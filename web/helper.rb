require "active_support/core_ext/numeric/time"

class Time
  def floor(seconds = 60)
    Time.at((self.to_f / seconds).floor * seconds)
  end
end

def day_helper item
	sold = Scan.where(item_id: item.id, purchase: true, time: Date.today.to_datetime..Date.today.next_day.to_datetime ).inject(0){|sum, x| sum+= x.quantity}
  amount = Scan.where(item_id: item.id, purchase: false, time: Date.today.to_datetime..Date.today.next_day.to_datetime ).inject(0){|sum, x| sum+= x.quantity} - sold
  amount = 0 if amount < 0
  [sold, amount]
end

def week_helper item
  sold = Scan.where(item_id: item.id, purchase: true, time: (Date.today - 7).to_datetime..Date.today.next_day.to_datetime ).inject(0){|sum, x| sum+= x.quantity}
  amount = Scan.where(item_id: item.id, purchase: false, time: (Date.today - 7).to_datetime..Date.today.next_day.to_datetime ).inject(0){|sum, x| sum+= x.quantity} - sold
  amount = 0 if amount < 0
  [sold, amount]
end

def month_helper item
  sold = Scan.where(item_id: item.id, purchase: true, time: Date.today.prev_month.to_datetime..Date.today.next_day.to_datetime ).inject(0){|sum, x| sum+= x.quantity}
  amount = Scan.where(item_id: item.id, purchase: false, time: Date.today.prev_month.to_datetime..Date.today.next_day.to_datetime ).inject(0){|sum, x| sum+= x.quantity} - sold
  amount = 0 if amount < 0
  [sold, amount]
end

def year_helper item
  sold = Scan.where(item_id: item.id, purchase: true, time: Date.today.prev_year.to_datetime..Date.today.next_day.to_datetime ).inject(0){|sum, x| sum+= x.quantity}
  amount = Scan.where(item_id: item.id, purchase: false, time: Date.today.prev_year.to_datetime..Date.today.next_day.to_datetime ).inject(0){|sum, x| sum+= x.quantity} - sold
  amount = 0 if amount < 0
  [sold, amount]
end

def alltime_helper item
  sold = Scan.where(item_id: item.id, purchase: true ).inject(0){|sum, x| sum+= x.quantity}
  amount = Scan.where(item_id: item.id, purchase: false).inject(0){|sum, x| sum+= x.quantity} - sold
  [sold, amount]
end

def parse_scans
  hash = Hash.new(0)
  @scans.sort_by{|x| x.time}.each do |scan|
    hour = scan.time.floor(10.minutes)
    while hour < Time.now
      hash[hour.to_i*1000] += scan.purchase ? Item.find(scan.item_id).cost : -Item.find(scan.item_id).retail_price
      hour += 10.minutes
    end
  end
  hash
end


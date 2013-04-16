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
    scan.time.to_date.upto(Date.today) do |date|
      hash[date.to_time.to_i*1000] += scan.purchase ? scan.item.cost : -scan.item.retail_price
    end
  end
  hash
end
require 'pry'

def consolidate_cart(cart)
  # code here
  consolidated = {}
  cart.each { |item|
    properties = {}
    item.each { |key, value|
      properties = value
      item = key
    }
    # binding.pry
    if consolidated[item]
      consolidated[item][:count] += 1
    else
      consolidated[item] = properties
      consolidated[item][:count] = 1
    end
  }
  consolidated
end

def apply_coupons(cart, coupons)
  # code here
  pp cart
  pp coupons
  newcart = cart

  cart.each { |item, properties|
    coupons.each { |coupon|
      if coupon[:item] == item && coupon[:num] <= properties[:count]
        if cart[item+" W/COUPON"]
          cart[item+" W/COUPON"][:count] += coupon[:num]
        else
          cart = cart.clone
          cart[item+" W/COUPON"] = {:price => coupon[:cost]/coupon[:num], :clearance => properties[:clearance], :count => coupon[:num]}
        end
          coupons = coupons.clone
          # binding.pry
          cart[item][:count] -= coupon[:num]
          coupons.delete(coupon)
          
          # if cart[item][:count] == 0
          #   cart.delete(item)
          # end
      end
    }
  }
  cart
end

def apply_clearance(cart)
  # code here
  cart.each { |item, properties|
    if properties[:clearance]
      properties[:price] = (properties[:price]*0.8).round(1)
    end
  }
end

def checkout(cart, coupons)
  # code here
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total = 0
  cart.each { |item, properties|
    total += properties[:price]* properties[:count]
  }
  if total > 100
    total = (total*0.9).round(2)
  end
  total
end


def generate_cart
	[].tap do |cart|
		rand(20).times do
			cart.push(items.sample)
		end
	end
end

def items
	[
		{"AVOCADO" => {:price => 3.00, :clearance => true}},
		{"KALE" => {:price => 3.00, :clearance => false}},
		{"BLACK_BEANS" => {:price => 2.50, :clearance => false}},
		{"ALMONDS" => {:price => 9.00, :clearance => false}},
		{"TEMPEH" => {:price => 3.00, :clearance => true}},
		{"CHEESE" => {:price => 6.50, :clearance => false}},
		{"BEER" => {:price => 13.00, :clearance => false}},
		{"PEANUTBUTTER" => {:price => 3.00, :clearance => true}},
		{"BEETS" => {:price => 2.50, :clearance => false}}
	]
end

def coupons
	[
		{:item => "AVOCADO", :num => 2, :cost => 5.00},
		{:item => "BEER", :num => 2, :cost => 20.00},
		{:item => "CHEESE", :num => 3, :cost => 15.00}
	]
end
def generate_coupons
	[].tap do |c|
		rand(2).times do
			c.push(coupons.sample)
		end
  end
  
end

cart = {
  
  "AVOCADO" => {:price => 3.00, :clearance => true, :count => 3},
  "KALE"    => {:price => 3.00, :clearance => false, :count => 1}

}

cpns = [{:item => "AVOCADO", :num => 2, :cost => 5.00}]
pp apply_coupons(cart,cpns)
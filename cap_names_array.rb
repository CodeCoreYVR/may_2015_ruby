names = %w(tom john jim eric)

# this will alter the names array by make every element in it capitalized
# then reversed
names.map! {|name| name.capitalize.reverse }

puts names

# you can also do:
names.map(&:capitalize)

# which is a shortcut for doing
names.map {|name| name.capitalize }

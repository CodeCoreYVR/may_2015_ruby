my_array = [1,2,3,4,5]

my_array.each do |num|
  puts number * 5
end

# this is just another syntax for passing a block to the 'each'
# method of the array
my_array.each {|num| puts number * 5 }

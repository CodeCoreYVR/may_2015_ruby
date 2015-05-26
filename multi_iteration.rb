array = [[1,2,3], [1,2,3], [1,2,3], [1,2,3]]

array.each {|i| i.each {|j| puts j }}

array.each do |sub_array|
  sub_array.each do |number|
    puts number
  end
end

flattened_array = array.flatten

flattened_array.each do |num|
  puts num
end

puts array.flatten

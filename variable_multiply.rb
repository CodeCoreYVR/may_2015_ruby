def multiply(a, *b)
  result = a
  b.each do |number|
    result *= number
  end
  result
end

puts multiply 5, 6
puts multiply 5,6,7,8,9,90,123
puts multiply 5

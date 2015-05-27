array = [] # Array.new

for num in 1..100
  if num % 3 == 0 && num % 5 == 0
    array << "FIZZBUZZ"
    # your can also do:
    # array.push("FIZZBUZZ")
    # or
    # array.push "FIZZBUZZ"
  elsif num % 5 == 0
    array << "BUZZ"
  elsif num % 3 == 0
    array << "FIZZ"
  else
    array << num
  end
end

print array

a = 15

# the code inside the if block will be executed if the given expression
# is evaluated to be true
if(a > 10)
  puts "The number is large"
# this will be checked if the first condition is not met
# elsif must be given an expression all the time
elsif(a > 5)
  puts "The number is medium"
# the code inside the else will be executed if non of the code inside
# the if and elsif's is executed
else
  puts "The number is small"
end

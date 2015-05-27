word = ""

for i in 1..100
  # if the number is divisible by three we contatenate "FIZZ" to the string
  # if i % 3 == 0
  #   word += "FIZZ"
  # end
  word += "FIZZ" if i % 3 == 0

  # if the number is divisible by five we contatenate "BUZZ" to the string
  # if i % 5 == 0
  #   word += "BUZZ"
  # end
  word += "BUZZ" if i % 5 == 0

  # if word == ""
  #   puts i
  # else
  #   puts word
  # end
  puts (word == "") ? i : word

  word = ""
end

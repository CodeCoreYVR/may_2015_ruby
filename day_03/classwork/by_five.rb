def by_five?(number)
  if number % 5 == 0
    return true
  else
    return false
  end
end

puts by_five?(15)
puts by_five?(51)

def by_five?(number)
  if number % 5 == 0
    true
  else
    false
  end
end

puts by_five?(15)
puts by_five?(51)

def by_five?(number)
  (number % 5 == 0) ? true : false
end

puts by_five?(15)
puts by_five?(51)


def by_five?(number)
  number % 5 == 0
end

puts by_five?(15)
puts by_five?(51)

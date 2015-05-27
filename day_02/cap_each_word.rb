print "Please enter a sentence"

sentence = gets.chomp

# STEP 1
# convert the sentence into an array of words
# we use the split method for this
words = sentence.split

# STEP 2
# capitalize every element in the array
# we user the map method for this
words.map! {|word| word.capitalize }

# STEP 3
# generate a sentence from the array
# we use the join method for this
cap_sentence = words.join(" ")

puts cap_sentence

# shorter solution
puts sentence.split.map {|word| word.capitalize }.join(" ")

# even shorter
p sentence.split.map(&:capitalize).join(" ")

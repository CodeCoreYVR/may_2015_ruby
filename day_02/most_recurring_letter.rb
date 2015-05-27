print "Please give me a sentence"

sentence = gets.chomp.gsub(" ", "")

# we use Hash.new and we give it a default value of 0
counts = Hash.new(0)

# this will go over every character in the string and it will increment
# the frequency of it in the counts hash by 1
# the hash will look something like:
# {"a" => 5, "x" => 1, "b" => 10 }
sentence.each_char {|char| counts[char] += 1 }

# this will sort the counts hash by the value which is in this case the frequency
# of the letter. The sort_by method will give us an array of arrays. The last
# one will be the biggest value. So we get the last array and to get the letter
# from it we fetch the first item which is the letter
print counts.sort_by {|k, v| v }.last.first

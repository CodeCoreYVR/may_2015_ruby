numbers = [1,2,3,4,5]

# this will give me back an array with every number in it multiplied by itself
# it won't alter the original array. For that you will have to use map!
# The returned result will be: [1,4,9,16,25]
numbers.map {|num| num * num }

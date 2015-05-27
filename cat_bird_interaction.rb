require "./cat.rb"
require "./bird.rb"

bird = Bird.new("Johnny")
cat  = Cat.new("Tom")

cat.catch bird

cat.eat 

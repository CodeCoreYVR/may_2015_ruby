# Write a class "ghost" that:
# - does not take any arguments
# - instantiates with a random color (white, yellow, pink, blue)
# - has a getter for "color"
class Ghost
  attr_reader :color
  def initialize
    @color = ["white", "yellow", "pink", "blue"].sample
  end
end

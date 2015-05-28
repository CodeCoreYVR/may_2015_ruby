# Write a class "Ball" that:
# - instantiates with up to 1 argument "ball_type"
# - if no argument is given, the default "ball_type" is "regular"
# - write a getter method for "ball_type"
class Ball
  attr_reader :ball_type
  def initialize(ball_type="regular")
    @ball_type = ball_type
  end
end

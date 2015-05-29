# Write a class "Pacman" that:
# - instantiates with no arguments and:
#   + 2 lives
#   + Zero points
#   + "regular" state
#   + super_time is set to zero
#
# - has the methods "eat_ball" and "eat_ghost"
#   (or just an "eat" method)
#   + each time Pacman eats a ball:
#     * super_time decreases by 1
#     * Pacman gains 1 point
#     * if the ball_type is "super"
#       - Pacman changes state to "super"
#       - super_time is set to 10
#   + each time Pacman eats a ghost:
#     * super_time descreases by 1
#     * if state is "super"
#       - Pacman gains 25 points
#     * if state is "regular"
#       - Pacman loses 1 life
#   + if super_time reaches 0, Pacman's state should be set to "regular"
#   + if Pacman has zero lives, and eats a ghost in "regular" state,
#     puts 'Game Over'
class Pacman
  def initialize
  end

  def eat_ball
  end

  def eat_ghost
  end
end

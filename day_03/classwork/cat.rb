require "./animal.rb"

class Cat < Animal
  attr_accessor :caught_bird

  def catch(bird)
    if rand >=  0.5
      @caught_bird        = bird
      @caught_bird.alive  = false
      puts "Caught the bird"
    else
      puts "Missed the bird"
    end
  end

  def eat
    if @caught_bird
      puts "eating bird #{@caught_bird.name}"
      @caught_bird = nil
    else
      puts "Hungry"
    end
  end

end

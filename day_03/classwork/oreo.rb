require "./cookie.rb"

# Cookie is called the parent class or super class
# Oreo is called the child class or sub class
class Oreo < Cookie
  attr_accessor :filling_type

  # you can "override" a method from the class you inherit from by simply
  # refining the method in this class
  def details
    puts "This is an Oreo cookie with #{filling_type} filling."
    super
  end

end

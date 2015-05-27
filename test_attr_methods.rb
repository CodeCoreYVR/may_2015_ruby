class TestAttrMethods
  attr_reader   :a
  attr_accessor :b
  attr_writer   :c

  def initialize(a, b = "Hello", c = "Bonjour!")
    @a, @b, @c = a, b, c
  end

  def greetings
    puts "#{@a} #{@b} #{@c}"
  end

end

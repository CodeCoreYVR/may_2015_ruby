class Cookie

  # this method will be called when a new object is instantiated
  # i.e. when you call:
  # Cookie.new
  def initialize(sugar_amount, flour_amount)
    @sugar_amount = sugar_amount
    @flour_amount = flour_amount
    # @@color = "Brown"
    puts "creating the cookie object"
  end

  # this method is used to get the @sugar_amount variable value
  # this method is called a "Getter" method
  def sugar_amount
    @sugar_amount
  end

  attr_reader :flour_amount
  # this is equivalent to:
  # def flour_amount
  #   @flour_amount
  # end

  # this method is used to set the @sugar_amount variable value
  # this method is called "Setter" method
  def sugar_amount=(new_amount)
    @sugar_amount = new_amount
  end

  attr_writer :flour_amount
  # def flour_amount=(new_amount)
  #   @flour_amount = new_amount
  # end

  attr_accessor :chip_count
  # this is equivalent to
  # attr_reader :chip_count
  # attr_writer :chip_count

  # def change_color(new_color)
  #   @@color = new_color
  # end
  #
  # def color
  #   @@color
  # end

  def details
    puts "This cookie has #{@sugar_amount}g of sugar and #{@flour_amount}g of flour"
  end

  # this defines a class method, this method can be called directly on the class
  # without having to instantiate an object.
  # for instance we can call it:
  # Cookie.info
  def self.info
    puts "I'm a Cookie class"
  end

  # defining a method like this will make it an "instance" or "object" method
  # which means we can call this method on an instance(object) of the class
  # for instance we can do:
  # c = Cookie.new
  # c.bake
  def bake
    "Baking baking..."
  end

  def bake_and_eat
    bake
    eat # calling private method eat
  end

  # in this case every method that is defined after the 'private' keyword until
  # the `end` keyword will be treated as a private method. Other private and
  # public methods in this class can call private methods. But not from outside
  # this class
  private

  def eat
    "nom nom nom..."
  end

end

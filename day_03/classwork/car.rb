class Car

  def initialize(model, type, capacity)
    # @model    = model
    # @type     = type
    # @capacity = capacity
    @model, @type, @capacity = model, type, capacity
  end

  def self.max_speed
    200
  end

  def drive
    ignite_engine
    puts "you're driving stop drinking"
  end

  def stop
    puts "you've stopped no idling"
  end

  def park
    puts "you're parked don't crash!"
  end

  private

  def pump_gas
    puts "pumping gas"
  end

  def ignite_engine
    puts "turn on the car!"
  end

end

class Bone
  # for our use case, we likely won't need to change the size after we initailize
  # so a reader is sufficient at this point
  attr_reader :size

  def initialize(size)
    @size = size
  end


end

require "./bone.rb"
require "./dog.rb"

dog = Dog.new("Brown", "Poodle")

dog.eat

bone_1 = Bone.new("big")
bone_2 = Bone.new("medium")
bone_3 = Bone.new("small")
bone_4 = Bone.new("extra big")

dog.give bone_1
dog.give bone_2
dog.give bone_3
dog.give bone_4

dog.eat
dog.eat
dog.eat
dog.eat

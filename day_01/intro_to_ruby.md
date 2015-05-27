# Intro to Ruby  
__IRB__  
Open up the terminal and in bash type
```bash
ruby -v
```  
Open up an Interactive Ruby Shell  
```bash
irb
```   
Play around with ruby  
```ruby
a = 1
b = a + 5
5 * 4 / 3
```  
Rails has its own version of irb called `rails console`. We'll talk more about this in upcoming classes.  
Try some more commands  
```ruby
print a
puts a
```  
The difference between print and puts is that puts returns a new line character, print dos not. Both return `nil`.  
Comments in ruby  
```ruby
# this is a comment
```  
You may also run ruby scripts from ruby files. Create a file and open it up with your preferred editor.  
```bash
subl test.rb
```  
Add some ruby code to the file  
```ruby
# test.rb
a = 5
b = a - 2
```  
To run this file from the command line, run `ruby test.rb`.  
  
Get some user input  
```ruby
puts "What is your name?"
a = gets.chomp #use chomp to remove a new line character

puts "Your Name is #{a}"
```  
and run the file from the command line.  
```bash
ruby test.rb  
```  
  
__Exercise 01__  
Write code to prompt users for their first name, then last name.  
```ruby
puts "What is your first name?"
first_name = gets.chomp

puts "What is your last name?"
last_name = gets.chomp
puts "Your name is #{first_name} #{last_name}"
```  
  
__Strings__  
Strings are defined using quotes. Let's make a string and check its class  
```irb
my_string = 'this is a string.'
my.string.class
```  
What is the difference between using single quotes (') and double quotes (")?  
```irb
my_string = "My name is \" Drew \" "

name = "Drew"

puts "My name is #{name}"
puts 'My name is #{name}'
```  
Some other string methods  
```irb
"drew".capitalize
"drew".upcase
"drew".downcase
"drew".reverse
"drew".rindex("a")
name = "Drew"
name.upcase   # non-destructive
name.upcase!  # desctructive (this will change the actual variable
```  
__String Exercises__  
Rdocs: [String](http://www.ruby-doc.org/core-2.1.0/String.html)  
1.) Try to find a way to swap the case of letters in the docs.  
```ruby
"Hello".swapcase
```  
2.) Try to replace a substring with another string  
```ruby
"Hello, friends".gsub('friends', 'world')
```  
3.) Try to replace double characters with single, e.g. "Hello" => "Helo"  
```ruby
"This      is useful    for removing additional space   .".squeeze(" ")
```  
__Math Operations__  
Examples  
```ruby
5 * 5
2 + 2 + 1
10 / 2
10 / 3        # This returns 3. It rounds it down. If we want the decimal value, we need to define it as a float
10.0 / 3      # 3.33333
235234.class  # Fixnum < Integer
235234235234235234235234235234235234235234235234.class # Bignum < Integer
1232.0.class  # Float < Number
10 % 3        # Returns the remainder: 1
10 % 2        # Returns 0 (no remainder)
10 % 2 == 0   # Returns true
```  
Write code that sets a variable b to the power of 2  
```ruby
b = 5
a = b ** 2
```  
Write code that asks a user for two inputs and then return the multiplication result  
```ruby
# multiplication_result.rb
puts "Enter an input for multiplication"
a = gets.chomp
a.to_i!

puts "Enter another input"
b = gets.chomp
b.to_i!
puts "#{a} times #{b} equals: #{a * b}"
```  
__Objects__  
In Ruby, everythign is an object. Let's look at some examples.  
```ruby
true
true.class        # TrueClass < Object
a = "<y stringsa fassfsda"
a.object_id       # Gives an object ID
true.object_id    # This will return a single object ID (dependent on Ruby version); a singleton. There is only one true object. 
10 > 5            # true
5  < 2            # false
10 > 5.object_id  # false
5.object_id       # singleton id
true && true      # true
true && false     # false
true && (10 > 5)  # true
true || false     # true
false || false    # false
1 + 1 * 5         # 6
1 + (1 * 5)       # It's better to show the order of operations explicitly
(1 + 1) * 5       # 10
(10 > 4) || false # true
10 >= 10 || false # true
a = 5
a == 4            # false
a == 5            # true
```  

__Conditionals__  
Let's try using `if .. elsif... else ... end`
```ruby
#testing_if.rb
puts "Give me a number"
number = gets.chomp.to_i

if number > 10
  puts "Your number is greater than 10"
elsif number > 5
  puts "Your number is greater than 5"
else
  puts "Your number is less than 6"
end
```  
1.) Write code that asks users for the year of their car and then prints: future, new, old or very old.  
```ruby
puts "What is the year of your car?"

year = gets.chomp.to_i

if year > 2014
  puts "Future car"
elsif year > 2010
  puts "New car"
elsif year > 1995
  puts "Old car"
else
  puts "Very old car"
end
```  
__While__  
While will continue *while* a condition is true. This example will print 1 to 50 to the terminal. Note that x is incremented everytime it loops, thus giving a stopping point, and preventing it from looping infinitely.  
```ruby
x = 1
while x <= 50
  puts x
  x += 1
end
```  
1.) Print numbers 5- to 1 using a while loop  
```ruby
x = 50
while x >= 1
  puts x
  x -= 1
end
```  
2.) Print the first 30 odd numbers using an *until* loop.  
```ruby
x = 1
count = 0
until x > 59
  puts x
  x += 2
end

# alternative method 1
until x > 59
  puts x unless x % 2 == 0
  x += 1
end

# alternative method 2
until x > 59
  puts x if x.odd?
  x += 1
end
```  
__For loops__  
We usually use for loops when we know from what number to what number we want to loop. We may use *while* when we are waiting until a condition is met.  
```ruby
# for.rb
for i in 3..10
  puts i
end
```  
1.) Write FizzBuzz in ruby: Write code that prints 1 to 100. If the number is divisible by 3, put *Fizz*, if it is divisible by 5, put *Buzz*, if it is divisible by 3 *and* 5, put *FizzBuzz*. Otherwise, put the number.  
```ruby
#fizzbuzz.rb

```  

__Type Checking__  
```ruby
"Hello CodeCore".is_a? String
"hello CodeCore".is_a? Integer
10.is_a? Integer
"asdfasdf".is_a? Integer
nil
nil.class
a = nil
a.capitalize      # undefined method `capitalize` for nil:NilClass
```  
**Note**: `nil` is different from `undefined`  
```ruby
a = nil
defined? b
defined? a        # local-variable
```

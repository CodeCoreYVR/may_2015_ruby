users = [{"first name" => "tam",  "last name" => "kbeili", "city" => "Burnaby"},
         {"first name" => "John", "last name" => "Smith",  "city" => "Richmond"}
        ]

users.each do |user|
  # puts "first name: #{user["first name"]} - last name: #{user["last_name"]}"
  # user in this case is a hash which is included in the users array
  user.each do |k, v|
    puts "#{k}: #{v.capitalize}"
  end
  puts "---------------"
end

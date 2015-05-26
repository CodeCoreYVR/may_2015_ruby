my_hash = { "BC" => ["Vancouver", "Richmond"],  "AB" => ["Edmonton", "Calgary"]}

my_hash.each do |prov, cities|
  puts "#{prov}: #{cities.join(", ")}"
end

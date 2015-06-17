# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
groups = {"faded paper figures" => {"dynamo" => "2008", "new medium" => "2010", "the Matter" => "2012", "relics" => "2014"},
          "pomegranates" => {"everything is alive" => "2008", "everybody come outside" => "2009", "one of us" => "2010", "heaven (modern outsider)" => "2012"},
          "summer heart" => {"never let me go" => "2011", "about a feeling" => "2012"},
          "white rabbits" => {"fort nightly" => "2007", "it's frightening" => "2009", "milk famous" => "2012"},
          "mystery jets" => {"making dens" => "2005", "zootime" => "2007", "twenty one" => "2008", "serotonin" => "2010", "radlands" => "2012"}}


groups.each do |name, albums|
  artist = Artist.create(name: name)
  albums.each do |title, release_year|
    artist.albums.create(name: title, release_year: release_year, artist_id: artist.id)
  end
end

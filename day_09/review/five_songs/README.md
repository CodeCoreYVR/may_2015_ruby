# Rails Review Day 8
Let's build an app called "Five Songs". Any visitor to this app can add
their favorite song or songs. The attributes a song has are:  
  * title
  * artist
  * album
  * youtube link
  
There should be two views. One view will have a form where users can input their favorite songs, and the main view will have an index of the five most recently input songs.
  
Let's start by creating a new rails app without tests and with a PostgeSQL database.
```
rails new five_songs -T -d postgresql
```

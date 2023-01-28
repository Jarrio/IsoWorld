# Haxeflixel Isometric Example
I initially made this project as I wanted to make an openworld isometric blockbased game in flixel. I ended up moving on to other things, I have
made this repo public just to give a ~~terrible~~ example of a way to handle isometric things.

Use this project as a learning tool, the code sucks and is messy, there's a bunch of commented code that I no longer remember what it does but i'll leave it in there incase its important. 

I got it running on new flixel as displayed below, there does seem to be a glitch with collision that happens intermittently and it goes off in a direction.

I have no intentions with supporting this project, but feel free to use it however you wish. 

Enjoy!

## Setup
I use the below library to generate the terrain/blocks from a seed. 
```
haxelib git libnoise https://github.com/memilian/libnoise/
```

## Movement
Use arrow keys to move and `z` to go down and `x` to go up
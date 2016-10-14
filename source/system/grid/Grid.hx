package system.grid;



import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.math.FlxRandom;

import system.entities.Block;
import system.entities.Basic;
//import system.grid.Chunk;
//import system.constants.Map;

class Grid {
    public var chunk_render_distance:Int = 2;
    public var map_camera:FlxCamera;
	public var chunks:Array<Block> = new Array<Block>();    
    public var chunkx:Int = 200;
    public var chunky:Int = 100;


    public function new () {
        map_camera = new FlxCamera(100, 50, 400, 400);
        map_camera.bgColor = FlxColor.BLACK;
        
    }

    public function LoadChunks() {
        var chunk_distance_x = Math.floor(map_camera.width / 128);
        var chunk_distance_y = Math.floor(map_camera.height / 64);
        FlxG.log.notice('x: ${chunk_distance_x} y: ${chunk_distance_y}');

        for (y in 2...7) {
            for (x in 7...12) {
                var random_height = new FlxRandom().int(1, 2);            
                for (z in 0...random_height) {                                                      
                    var new_chunk = new Block(x, y, z);
                    chunks.push(new_chunk); 
                      


                    
                    
                    
                //chunks.add(chunk_outline);
                }
            }
        }
    }    
}
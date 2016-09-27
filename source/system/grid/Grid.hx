package system.grid;

import flixel.FlxSprite;
import system.grid.Tile;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import system.helpers.Isometric;
import system.grid.Chunk;

class Grid {
    public var chunk_render_distance:Int = 2;
    public var map_camera:FlxCamera;
	public var chunks:FlxGroup = new FlxGroup();    
    public var chunkx:Int = 200;
    public var chunky:Int = 100;

    public function new () {
        map_camera = new FlxCamera(100, 50, 400, 400);
        map_camera.bgColor = FlxColor.BLUE;
        chunks.camera = map_camera;
    }

    public function LoadChunks() {
        for (y in 0...chunk_render_distance) {
            for (x in 0...chunk_render_distance) {
                var chunk_size = 3;

                var chunk_width = chunk_size * 32;
                var chunk_height = chunk_size * 16;                
                var chunk_coords = Isometric.Chunk2dToIso(new FlxPoint(x, y));                

                var new_chunk = new Chunk();


                new_chunk.x = chunk_coords.x;
                new_chunk.y = chunk_coords.y;

                chunks.add(new_chunk);
            }
        }
    }

    public function CalculateTiles() {/*
        for (cellY in 0...10) {            
            for (cellX in 0...10) {
			    var oldPoint = new FlxPoint(cellX, cellY);
			    var newPoint = Isometric.TwoDToIso(oldPoint);    
                var reverse = Isometric.IsoTo2D(newPoint);

                var newTile = new Tile(cellX, cellY, newPoint.x, newPoint.y);
                newTile.x = newPoint.x;
                newTile.y = newPoint.y;

                
                FlxG.log.notice('OldPointColumn: ${cellX} | OldPointRow: ${cellY}');
                FlxG.log.notice('NewPointX: ${newPoint.x} | NewPointY: ${newPoint.y}');
                FlxG.log.notice('ReversePointX: ${reverse.x} | ReversePointY: ${reverse.y}');
                
                StoredTiles[StoredTiles.length] = newTile;
            }
        }*/
    }
}
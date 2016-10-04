package system.grid;

import flixel.FlxSprite;
import system.grid.Tile;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import system.helpers.Isometric;
import system.grid.Chunk;
using flixel.util.FlxSpriteUtil;

import system.constants.Map;

class Grid {
    public var chunk_render_distance:Int = 2;
    public var map_camera:FlxCamera;
	public var chunks:Array<Chunk> = new Array<Chunk>();    
    public var chunkx:Int = 200;
    public var chunky:Int = 100;

    public function new () {
        map_camera = new FlxCamera(100, 50, 400, 400);
        map_camera.bgColor = FlxColor.BLUE;
        
    }

    public function LoadChunks() {
        var chunk_distance_x = Math.floor(map_camera.width / 128);
        var chunk_distance_y = Math.floor(map_camera.height / 64);
        FlxG.log.notice('x: ${chunk_distance_x} y: ${chunk_distance_y}');

        for (y in 0...chunk_distance_y) {
            for (x in 0...chunk_distance_x) {               



                var chunk_coords = Isometric.Chunk2dToIso(new FlxPoint(x, y));                
                var new_chunk = new Chunk(x, y);

                var chunk_outline = new FlxSprite(0, 0);                
                chunk_outline.makeGraphic(64, 64, FlxColor.TRANSPARENT);                
                var lineStyle:LineStyle = { color: FlxColor.RED, thickness: 1 };
                chunk_outline.drawRect(0, 0, 64, 64, FlxColor.TRANSPARENT,  lineStyle);
                chunk_outline.angle = 45;
                
                chunk_outline.x = chunk_coords.x;
                chunk_outline.y = chunk_coords.y;

                new_chunk.x = chunk_coords.x;
                new_chunk.y = chunk_coords.y;

                chunks.push(new_chunk);
                //chunks.add(chunk_outline);
            }
        }
    }

    public function GetChunkPoint(position:FlxPoint) {
        var newX = position.x;
        var newY = position.y;

        var screen:FlxPoint = new FlxPoint(0, 0);

        screen.x = Math.ceil((newX / Map.BASE_TILE_HALF_WIDTH + newY / Map.BASE_TILE_HALF_HEIGHT) / Map.CHUNK_SIZE);
        screen.y = Math.ceil((newY / Map.BASE_TILE_HALF_HEIGHT - (newX / Map.BASE_TILE_HALF_WIDTH)) / Map.CHUNK_SIZE);
                                        
        return(screen);        
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
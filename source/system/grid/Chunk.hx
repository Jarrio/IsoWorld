package system.grid;

import flixel.FlxSprite;
import system.grid.Tile;
import flixel.FlxG;
import flixel.math.FlxPoint;

import system.helpers.Isometric;

class Chunk {
    public var chunk_size:Int = 5;
    public var chunk_tiles:Array<Tile> = new Array<Tile>();

    public function new() {
        for (y in 0...chunk_size) {
            for (x in 0...chunk_size) {
                var coord = new FlxPoint(x, y);
                var point = Isometric.TwoDToIso(coord);
                
                var tile = new Tile(x, y);
                chunk_tiles[chunk_tiles.length] = tile;
            }
        }
    }

}
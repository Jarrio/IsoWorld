package system.grid;

import flixel.FlxSprite;
import system.grid.Tile;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup;

import system.helpers.Isometric;
import system.entities.Block;

class Chunk extends FlxSpriteGroup {
    public var chunk_size:Int = 3;
    public var chunk_tiles:FlxGroup = new FlxGroup();

    public function new() {
        super();
        for (y in 0...chunk_size) {
            for (x in 0...chunk_size) {
                var coord = new FlxPoint(x, y);
                var point = Isometric.TwoDToIso(coord);
                
                var tile = new Block(x, y);
                add(tile);
                //add(tile.number);
            }
        }
    }

}
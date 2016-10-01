package system.grid;

import flixel.FlxSprite;
import system.grid.Tile;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup;

import system.helpers.Isometric;
<<<<<<< HEAD
import system.entities.Block;
=======
import system.constants.Map;
>>>>>>> a4cb3f87736ae1bc766632748a38caa5efe6b4b4

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
                add(tile.number);
            }
        }
    }

    public function GetTilePoint(position:FlxPoint):FlxPoint {
        var newX = position.x;
        var newY = position.y;

        var screen:FlxPoint = new FlxPoint(0, 0);

        screen.x = (newX / Map.BASE_TILE_HALF_HEIGHT + newY / Map.BASE_TILE_HALF_WIDTH) / 2;
        screen.y = (newY / Map.BASE_TILE_HALF_WIDTH - (newX / Map.BASE_TILE_HALF_HEIGHT)) / 2;

        return screen;
    }

}
package system.grid;

import flixel.FlxSprite;
import system.grid.Tile;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxRandom;
import flixel.util.FlxSort;

import system.helpers.Isometric;
import system.entities.Block;
import system.entities.Basic;
import system.entities.GrassBlock;
import system.constants.Map;
import haxe.ds.Vector;

class Chunk extends FlxTypedSpriteGroup<Basic>{
    public var chunk_size:Int = 3;
    public var blocks:Array<Basic> = new Array<Basic>();
    

    public function new(x:Int, y:Int, ?graphic = null) {
        var chunk_point = Isometric.Chunk2dToIso(new FlxPoint(x, y));               
        super(chunk_point.x, chunk_point.y);

        for (iy in 0...(chunk_size)) {
            var random = new FlxRandom().int(1,3);
            for (ix in 0...(chunk_size)) {
                
                for (iz in 0...random) {
                    var newGrass = new GrassBlock(ix, iy, iz);
                    blocks.push(newGrass);
                    add(newGrass);
                }
                //add(tile.number);
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
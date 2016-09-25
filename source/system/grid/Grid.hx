package system.grid;

import flixel.FlxSprite;
import system.grid.Tile;
import flixel.FlxG;
import flixel.math.FlxPoint;

import system.helpers.Isometric;

class Grid {
    public var chunk_size:Int = 2;
    public var chunks:Array<Chunk> = new Array<Chunk>();

    public function new () {

    }

    public function LoadChunks() {
        for (y in 0...chunk_size) {
            for (x in 0...chunk_size) {
                
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
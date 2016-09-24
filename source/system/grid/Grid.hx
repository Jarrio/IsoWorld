package system.grid;

import flixel.FlxSprite;
import system.grid.Tile;
import flixel.FlxG;
import flixel.math.FlxPoint;

class Grid {
    public var StoredTiles:Array<Tile> = new Array<Tile>();
    public function new () {

    }

    public function CalculateTiles() {
        for (cellY in 0...10) {            
            for (cellX in 0...10) {
                var newTile = new Tile();
                var TileX = cellY * newTile.width;
                var TileY = cellX * newTile.height;            
                
                newTile.x = TileX;
                newTile.y = TileY;

			    var oldPoint = new FlxPoint(cellX, cellY);
			    var newPoint = TwoDToIso(oldPoint);    
                                  
                newTile.x = newPoint.x;
                newTile.y = newPoint.y;
                StoredTiles[StoredTiles.length] = newTile;
            }
        }
    }

    public function IsoTo2D(pt:FlxPoint):FlxPoint{
        var tempPt:FlxPoint = new FlxPoint(0, 0);
        tempPt.x = (2 * pt.y + pt.x) / 2;
        tempPt.y = (2 * pt.y - pt.x) / 2;
        return(tempPt);
    }

    public function TwoDToIso(point:FlxPoint):FlxPoint{
        var StartX:Float = 0;
        var StartY:Float = FlxG.height / 2;
        var tempPt:FlxPoint = new FlxPoint(0, 0);

        var screenX = StartX + ((point.x * 64  / 2) + (point.y * 64  / 2));
        var screenY = StartY + ((point.y * 32 / 2) - (point.x * 32 / 2));      
        tempPt.x = screenX; 
        tempPt.y = screenY;
        return tempPt;
    }    
}
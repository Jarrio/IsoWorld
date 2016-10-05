package system.helpers;

import flixel.FlxG;
import flixel.math.FlxPoint;
import system.constants.Map;

class Isometric {
    static public function IsoTo2D(map:FlxPoint, z:Int):FlxPoint{
        var screen:FlxPoint = new FlxPoint(0, 0);
        
        var newX = map.x / Map.BASE_TILE_HALF_WIDTH;
        var newY = map.y / Map.BASE_TILE_HALF_HEIGHT;
        var newZ = z * Map.BASE_TILE_HALF_HEIGHT;

        screen.x = (newX + newY) / 2;                              
        screen.y = (newY - newX + newZ) / 2;                              
        return(screen);
    }

    static public function TwoDToIso(map:FlxPoint, z:Int = 0):FlxPoint{
        //var StartX:Float = (FlxG.width / 2) - 32;
        //var StartY:Float = 100;
        var screen:FlxPoint = new FlxPoint(0, 0);

        //screen.x =  ((map.x - map.y) * Map.BASE_TILE_HALF_WIDTH);
        //screen.y =  ((map.y + map.x) * Map.BASE_TILE_HALF_HEIGHT);        

        screen.x =  ((map.x - map.y) * Map.BASE_TILE_HALF_WIDTH);
        //FlxG.log.notice(z * Map.BASE_TILE_HALF_HEIGHT);
        screen.y =  ((map.y + map.x - (z * Map.BASE_TILE_HALF_HEIGHT)) * Map.BASE_TILE_HALF_HEIGHT); 
        return screen;
    }

    static public function PlayerToIso(map:FlxPoint, z:Int = 0):FlxPoint{
        //var StartX:Float = (FlxG.width / 2) - 32;
        //var StartY:Float = 100;
        var screen:FlxPoint = new FlxPoint(0, 0);

        screen.x =  ((map.x - map.y) * Map.BASE_TILE_HALF_WIDTH) + (30 / 2);
        screen.y =  ((map.y + map.x) * Map.BASE_TILE_HALF_HEIGHT) - (32 / 4);        

        return screen;
    }

    static public function ChunkIsoTo2D(map:FlxPoint):FlxPoint{
        //var StartX:Float = (FlxG.width / 2) - 32;
        //var StartY:Float = 100;
        var newX = map.x;
        var newY = map.y;

        var screen:FlxPoint = new FlxPoint(0, 0);

        screen.x = ((newX / Map.BASE_TILE_HALF_WIDTH + newY / Map.BASE_TILE_HALF_HEIGHT) / Map.CHUNK_SIZE) / 2;
        screen.y = ((newY / Map.BASE_TILE_HALF_HEIGHT - (newX / Map.BASE_TILE_HALF_WIDTH)) / Map.CHUNK_SIZE) / 2;
        
        //screen.x =  ((map.x + map.y) / (Map.BASE_TILE_HALF_WIDTH * Map.CHUNK_SIZE));
        //screen.y =  ((map.x - map.y) / (Map.BASE_TILE_HALF_HEIGHT * Map.CHUNK_SIZE));        
                                         
                                        
        return(screen);
    }

    static public function GetChunkPoint(position:FlxPoint) {
        var newX = position.x;
        var newY = position.y;

        var screen:FlxPoint = new FlxPoint(0, 0);

        screen.x = Math.ceil((newX / Map.BASE_TILE_HALF_WIDTH + newY / Map.BASE_TILE_HALF_HEIGHT) / Map.CHUNK_SIZE);
        screen.y = Math.ceil((newY / Map.BASE_TILE_HALF_HEIGHT - (newX / Map.BASE_TILE_HALF_WIDTH)) / Map.CHUNK_SIZE);
                                        
        return(screen);        
    }

    static public function Chunk2dToIso(map:FlxPoint):FlxPoint{
        var screen:FlxPoint = new FlxPoint(0, 0);

        screen.x =  ((map.x - map.y) * (Map.BASE_TILE_HALF_WIDTH * Map.CHUNK_SIZE));
        screen.y =  ((map.x + map.y) * (Map.BASE_TILE_HALF_HEIGHT * Map.CHUNK_SIZE));    

        return screen;
    }

    static public function ChunkLine2dToIso(map:FlxPoint):FlxPoint{
        var screen:FlxPoint = new FlxPoint(0, 0);

        screen.x =  ((map.x - map.y) * 1);
        screen.y =  ((map.x + map.y) * 50);        

        return screen;
    }    
    /**
        * convert a 2d point to specific tile row/column
        * */
    static public function GridCordsFromScreen(map:FlxPoint):FlxPoint {
        //var StartX:Float = (FlxG.width / 2) - 32;
        //var StartY:Float = 100;
        var newX = map.x ;
        var newY = map.y ;

        var screen:FlxPoint=new FlxPoint(0,0);
        screen.x = Math.floor((newX / 32 + newY / 16) / 2);
        screen.y = Math.floor((newY / 16 - (newX / 32)) / 2);
        
        return(screen);
    }

    /**
        * convert specific tile row/column to 2d point
        * */
    static public function get2dFromTileCoordinates(pt:FlxPoint, tileHeight:Int):FlxPoint{
        var tempPt:FlxPoint=new FlxPoint(0,0);
        tempPt.x=pt.x*tileHeight;
        tempPt.y=pt.y*tileHeight;

        return(tempPt);
    }    
}


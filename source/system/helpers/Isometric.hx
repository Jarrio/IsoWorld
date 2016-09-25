package system.helpers;

import flixel.FlxG;
import flixel.math.FlxPoint;

class Isometric {
    static public function IsoTo2D(map:FlxPoint):FlxPoint{
        //var StartX:Float = (FlxG.width / 2) - 32;
        //var StartY:Float = 100;
        var newX = map.x;
        var newY = map.y;

        var screen:FlxPoint = new FlxPoint(0, 0);

        screen.x = (newX / 32 + newY / 16) / 2;
        screen.y = (newY / 16 - (newX / 32)) / 2;
                                         
                                        
        return(screen);
    }

    static public function TwoDToIso(map:FlxPoint):FlxPoint{
        //var StartX:Float = (FlxG.width / 2) - 32;
        //var StartY:Float = 100;
        var screen:FlxPoint = new FlxPoint(0, 0);

        screen.x =  ((map.x - map.y) * 32);
        screen.y =  ((map.x + map.y) * 16);        

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


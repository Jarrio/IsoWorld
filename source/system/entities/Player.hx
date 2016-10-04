package system.entities;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.graphics.FlxGraphic;
import flixel.tweens.FlxTween;

using flixel.util.FlxSpriteUtil;
import system.constants.BasicTypes;

import system.helpers.Isometric;

class Player extends Basic {

    public var Speed:Int = 1;
    public var Movekey:Bool = false;

    public var PointX:Int = 0;
    public var PointY:Int = 0;


    
    public function new(?_x:Float, ?_y:Float, ?graphic:String) {
        PointX = Std.int(_x);
        PointY = Std.int(_y);

        var newPoint = Isometric.TwoDToIso(new FlxPoint(PointX, PointY));          
        type = BasicTypes.Player;
        x = newPoint.x;
        y = newPoint.y;

        z = 1;
        super(x, y, AssetPaths.player_iso__png);
    }

    override public function update(elapsed:Float):Void {
        var newY = y;
        var newX = x;
        var point = Isometric.TwoDToIso(Isometric.IsoTo2D(new FlxPoint(x, y), z));

        if (FlxG.keys.anyJustPressed(['W', 'Up'])) {
            PointY -= Speed;
            Movekey = true;
        } else if (FlxG.keys.anyJustPressed(['S', 'Down'])) {
            PointY += Speed;
            Movekey = true;
        } else if (FlxG.keys.anyJustPressed(['A', 'Left'])) {
            PointX -= Speed;
            Movekey = true;
        } else if (FlxG.keys.anyJustPressed(['D', 'Right'])) {
            PointX += Speed;
            Movekey = true;
        } else if (FlxG.keys.justPressed.ZERO) {
            z += 1;
        } else if (FlxG.keys.justPressed.NINE) {
            z -= 1;
        }

        if (Movekey) {            
            var movePoint = Isometric.TwoDToIso(new FlxPoint(PointX, PointY),z);
            x = movePoint.x + (width / 2) ;
            y = movePoint.y - (height / 4) ;
            Movekey = false;
            //FlxG.watch.addQuick("IsoPoint: ", 'X: ${isoPoint.x} Y: ${isoPoint.y}');
        }
        //var depth_point = Isometric.IsoTo2D(new FlxPoint(x, y));
        //var depth_point = Isometric.IsoTo2D(new FlxPoint(x, y));
        //FlxG.watch.addQuick("Depth Point: ", depth_point.toString());
        
		FlxG.watch.addQuick("Player Depth Point: ", 'x: ${PointX} - y: ${PointY} - z: ${z}');
        depth = Math.floor((x - (width / 2)) + (y + (height / 4)) + z);
        
    } 

    function MovePlayer(_x:Float, _y:Float, ?_z:Int) {
        var point = Isometric.TwoDToIso(Isometric.IsoTo2D(new FlxPoint(_x, _y), z));
        return point;
    }

    
}
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
    public var PointZ:Int = 1;


    
    public function new(?_x:Float, ?_y:Float, ?graphic:String) {
        PointX = Std.int(_x);
        PointY = Std.int(_y);

        var newPoint = Isometric.TwoDToIso(new FlxPoint(PointX, PointY));          
        type = BasicTypes.Player;
        x = newPoint.x;
        y = newPoint.y;

        
        super(x, y, AssetPaths.player_iso__png);
        set_iso_coords(PointX, PointY, PointZ);
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
            PointZ += 1;
        } else if (FlxG.keys.justPressed.NINE) {
            PointZ -= 1;
        }

        if (Movekey) {            
            var movePoint = Isometric.TwoDToIso(new FlxPoint(PointX, PointY),PointZ);
            x = movePoint.x + (width / 2) ;
            y = movePoint.y - (height / 4) ;
            Movekey = false;
            set_iso_coords(PointX, PointY, PointZ);
        }

        
    } 

    function MovePlayer(_x:Float, _y:Float, ?_z:Int) {
        var point = Isometric.TwoDToIso(Isometric.IsoTo2D(new FlxPoint(_x, _y), _z));
        return point;
    }

    
}
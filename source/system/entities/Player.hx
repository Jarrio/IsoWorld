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

    public var Speed:Int = 16;
    public var Movekey:Bool = false;
    
    public function new(?x:Float, ?y:Float, ?graphic:String) {        
        var newPoint = Isometric.TwoDToIso(new FlxPoint(4, 4));          
        type = BasicTypes.Player;
        x = newPoint.x;
        y = newPoint.y;

        z = 1;
        super(x, y, AssetPaths.player_iso__png);
    }

    override public function update(elapsed:Float):Void {
        var newY = y;
        var newX = x;
        var point = Isometric.TwoDToIso(Isometric.IsoTo2D(new FlxPoint(x, y)));

        if (FlxG.keys.anyJustPressed(['W', 'Up'])) {
            newY -= Speed;
            Movekey = true;
        } else if (FlxG.keys.anyJustPressed(['S', 'Down'])) {
            newY += Speed;
            Movekey = true;
        } else if (FlxG.keys.anyJustPressed(['A', 'Left'])) {
            newX -= Speed;
            Movekey = true;
        } else if (FlxG.keys.anyJustPressed(['D', 'Right'])) {
            newX += Speed;
            Movekey = true;
        } else if (FlxG.keys.justPressed.ZERO) {
            z += 1;
        } else if (FlxG.keys.justPressed.NINE) {
            z -= 1;
        }

        if (Movekey) {            
            var movePoint = MovePlayer(newX, newY);
            x = movePoint.x;
            y = movePoint.y;
            Movekey = false;
            //FlxG.watch.addQuick("IsoPoint: ", 'X: ${isoPoint.x} Y: ${isoPoint.y}');
        }

        depth = x + y + z;
        
    } 

    function MovePlayer(_x:Float, _y:Float, ?_z:Int) {
        var point = Isometric.TwoDToIso(Isometric.IsoTo2D(new FlxPoint(_x, _y)));
        return point;
    }

    
}
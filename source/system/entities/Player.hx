package system.entities;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxG;

import system.helpers.Isometric;

class Player extends FlxSprite {

    public var Speed:Int = 1;
    public var Movekey:Bool = false;

    public function new() {
        super();
        var newPoint = Isometric.TwoDToIso(new FlxPoint(4, 4));
        this.loadGraphic(AssetPaths.player_iso__png);
        x = newPoint.x + 16;
        y = newPoint.y - 7;
        this.visible = false;
    }

    override public function update(elapsed:Float):Void {
        var newY = y;
        var newX = x;
        
        if (FlxG.keys.anyJustPressed(['W', 'Up'])) {
            y -= Speed * height;
            Movekey = true;
        } else if (FlxG.keys.anyJustPressed(['S', 'Down'])) {
            y += Speed * height;
            Movekey = true;
        } else if (FlxG.keys.anyJustPressed(['A', 'Left'])) {
            x -= Speed * (width);
            Movekey = true;
        } else if (FlxG.keys.anyJustPressed(['D', 'Right'])) {
            x += Speed * (width);
            Movekey = true;
        }

        if (FlxG.keys.justReleased.ANY && Movekey) {
            Movekey = false;

            var point = Isometric.TwoDToIso(Isometric.IsoTo2D(new FlxPoint(x, y)));
            x = point.x;
            y = point.y;

            //FlxG.watch.addQuick("IsoPoint: ", 'X: ${isoPoint.x} Y: ${isoPoint.y}');
        }
    } 
}
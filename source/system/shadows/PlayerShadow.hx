package system.shadows;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.graphics.FlxGraphic;
import flixel.tweens.FlxTween;

using flixel.util.FlxSpriteUtil;
import system.constants.BasicTypes;

import system.helpers.Isometric;

class PlayerShadow extends Basic {
    
    public function new(?_x:Float, ?_y:Float, ?graphic:String) {
        PointX = Std.int(_x);
        PointY = Std.int(_y);
        super(_x, _y, AssetPaths.)
    }
}
package system.entities;

import system.constants.BlockTypes;
import system.entities.interfaces.BlockPattern;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;

import system.helpers.Isometric;

class Block implements BlockPattern extends FlxSprite {

    public var z:Int;
    public var id:Int;
    public var type:BlockTypes;
    
    public function new(cellx:Int, celly:Int) {
        var _point = Isometric.TwoDToIso(new FlxPoint(cellx, celly));

        super(_point.x, _point.y);
        loadGraphic(AssetPaths.base_cube__png);
    } 
}
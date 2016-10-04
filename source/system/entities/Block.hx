package system.entities;

import system.constants.BlockTypes;
import system.entities.interfaces.BlockPattern;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;

import system.helpers.Isometric;
import system.entities.Basic;

class Block implements BlockPattern extends Basic {

    public var block_type:BlockTypes;
    
    public function new(cellx:Int, celly:Int, graphic:String = AssetPaths.base_cube__png) {
        var _point = Isometric.TwoDToIso(new FlxPoint(cellx, celly));
        
        super(_point.x, _point.y, graphic);
    } 
}
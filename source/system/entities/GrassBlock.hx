package system.entities;

import system.constants.BlockTypes;
import system.constants.BasicTypes;
import system.entities.interfaces.BlockPattern;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.util.FlxCollision;
import system.helpers.Isometric;
import flixel.FlxObject;
import flixel.FlxG;

class GrassBlock implements BlockPattern extends Basic {

    public var block_type:BlockTypes;
    public var blocktext:String = "";

    public function new(cellx:Int, celly:Int, cellz:Int = 0) {        
        var _point = Isometric.TwoDToIso(new FlxPoint(cellx, celly), cellz);
        type = BasicTypes.Block;
        z = cellz;

        super(_point.x, _point.y, AssetPaths.green_cube__png);
        depth = x + y + z;
        this.allowCollisions = FlxObject.UP;
        blocktext = 'x: ${x} - y: ${y} - z: ${z}';
    } 

    

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if (FlxG.mouse.overlaps(this)) {
            color = FlxColor.RED;
            FlxG.watch.addQuick("Block:", blocktext);
            FlxG.watch.addQuick("Block Depth:", depth);
        } else {
            color = FlxColor.WHITE;
        }
        
    }
}
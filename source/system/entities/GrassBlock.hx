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
    public var startup:Bool = true;
    
    


    public function new(cellx:Int, celly:Int, cellz:Int) {  
        var _point = Isometric.TwoDToIso(new FlxPoint(cellx, celly), cellz);
        super(_point.x, _point.y, AssetPaths.green_cube__png);
        
        blocktext = 'x: ${cellx} - y: ${celly} - z: ${cellz}';

        var _reverse = Isometric.IsoTo2D(new FlxPoint(x, y), cellz);
        set_iso_coords(_reverse.x, _reverse.y, cellz);      
        
        MinXRelative = -32;
        MaxXRelative = 32;
         
        MinYRelative = -32;
        MaxYRelative = 32;

        MinZRelative = -32;
        MaxZRelative = 32;             
        //trace('ox: ${cellx} oy: ${celly} ± nx: ${oldpoint.x} ny: ${oldpoint.y} ± gx: ${this.x} gy: ${this.y}');
    } 

    

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if (startup) depth = Math.floor(x+y+z); startup = false;
        if (FlxG.mouse.overlaps(this)) {
            color = FlxColor.RED;
            FlxG.watch.addQuick("Block:", blocktext);
            FlxG.watch.addQuick("Block Depth:", IsoDepth);
            FlxG.watch.addQuick("Block Axis: ", 'x: ${x} - y: ${y} - z: ${z}');            
        } else {
            color = FlxColor.WHITE;
        }
        
    }
}
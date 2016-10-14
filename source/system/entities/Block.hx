package system.entities;

import flixel.FlxG;
import system.helpers.Isometric;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Block extends Basic {

    public function new(_x:Int, _y:Int, _z:Int) {
        super();
        
        Entity = "Block";
        var back_point = Isometric.TwoDToIso(getGraphicMidpoint());

    
        
        loadGraphic(AssetPaths.green_cube__png);
        this.centerOffsets(true);        
        this.centerOrigin();
        MinXRelative = -32;
        MaxXRelative = 32;
         
        MinYRelative = -16;
        MaxYRelative = 16;

        MinZRelative = -32;
        MaxZRelative = 32;
        set_iso_coords(_x, _y, _z);
        //trace('ox: ${cellx} oy: ${celly} ± nx: ${oldpoint.x} ny: ${oldpoint.y} ± gx: ${this.x} gy: ${this.y}');
        /*MinXRelative = -1;
        MaxXRelative = 1;
         
        MinYRelative = -1;
        MaxYRelative = 1;

        MinZRelative = -1;
        MaxZRelative = 1;*/


        //trace('X: ${HalfWidthX} | Y: ${HalfWidthY}'); 
        //trace('WidthX: ${WidthX} | WidthY: ${WidthY} | HeightZ: ${HeightZ}');

    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        //if (startup) depth = Math.floor(x+y+IsoZ); startup = false;
        if (FlxG.mouse.overlaps(this)) {
            if (FlxG.mouse.justPressed) {
                //FlxG.log.notice(return_debug_values('Block ${IsoDepth}'));
                FlxG.log.notice('Type: {${this.Entity}} | x: ${this.x} | y: ${this.y} | z: ${this.z}');
            }
            color = FlxColor.CYAN;
            FlxG.watch.addQuick("Block Depth", '${IsoDepth}');
            FlxG.watch.addQuick("Block Axis", 'x: ${x} | y: ${y} |  z: ${z}');
            FlxG.watch.addQuick("Block Coords", 'x: ${IsoX} | y: ${IsoY} | z:${IsoZ}');
            // FlxG.watch.addQuick("Block Min", 'x: ${MinX} | y: ${MinY} | z:${MinZ}'); 
            // FlxG.watch.addQuick("Block Max", 'x: ${MaxX} | y: ${MaxY} | z:${MaxZ}'); 
                      
        } else {
            color = FlxColor.WHITE;
        }
        
    }    
}
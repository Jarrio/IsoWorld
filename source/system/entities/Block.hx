package system.entities;

import flixel.FlxCamera;
import system.entities.IsoSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class Block extends IsoSprite {
    public function new(x:Float, y:Float, z:Float, ?graphic:String) {
        if (graphic == null) {
            graphic = AssetPaths.green_cube_v2__png;
        }
        super(x, y, z, graphic);        
        this.entity = "Block";
        this.active = false;
        this.iso_bounds.weight = 100;
        this.iso_bounds.post_update = true;
        this.iso_bounds.immovable = true;
        
    }
    
    override public function update(elapsed:Float) {
        super.update(elapsed);
        #if windows
        if (FlxG.mouse.overlaps(this)) {
            if (FlxG.mouse.justPressed) {
                //FlxG.log.notice(return_debug_values('Block ${IsoDepth}'));
                FlxG.log.notice("Block ID: " + ${this.ID});
            }
            color = FlxColor.GRAY;

            // FlxG.watch.addQuick("Block Min", 'x: ${MinX} | y: ${MinY} | z:${MinZ}'); 
            // FlxG.watch.addQuick("Block Max", 'x: ${MaxX} | y: ${MaxY} | z:${MaxZ}'); 
                      
        } else {
            color = FlxColor.WHITE;
        }
        #end    
    }
}
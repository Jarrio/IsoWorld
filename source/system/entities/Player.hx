package system.entities;

import flixel.graphics.FlxGraphic;
import system.entities.IsoSprite;
import flixel.util.FlxColor;
import flixel.FlxG;

class Player extends IsoSprite {
    public function new(x:Float, y:Float, z:Float, ?graphic:String) {
        if (graphic == null) {
            graphic = AssetPaths.green_cube_v2__png;            
        }        
        super(x, y, z, graphic);
        color = FlxColor.RED;
        
        this.entity = "Player";
    }
    
    public var Speed:Float = 0.5;
    public var Movekey:Bool = false;
    override public function update(elapsed:Float) {
        #if windows
      if (FlxG.keys.anyPressed(['W', 'Up'])) {
            this.iso_y = -Speed;
            Movekey = true;
        } else if (FlxG.keys.anyPressed(['S', 'Down'])) {
            this.iso_y = Speed;
            Movekey = true;
        } else if (FlxG.keys.anyPressed(['A', 'Left'])) {
            this.iso_x = -Speed;
            Movekey = true;
        } else if (FlxG.keys.anyPressed(['D', 'Right'])) {
            this.iso_x = Speed;
            Movekey = true;
        } else if (FlxG.keys.justPressed.X) {
            this.iso_z = -1;
            Movekey = true;
        } else if (FlxG.keys.justPressed.Z) {
            this.iso_z = 1;
            Movekey = true;
        }
        #end
        

        if (Movekey) {  
            Movekey = false;
            this.ResetBounds();         
        }          
    }
}
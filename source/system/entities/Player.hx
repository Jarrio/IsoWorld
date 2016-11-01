package system.entities;

import flixel.graphics.FlxGraphic;
import system.entities.IsoSprite;
import flixel.util.FlxColor;
import flixel.FlxG;

class Player extends IsoSprite {
    public function new(x:Float, y:Float, z:Float, ?graphic:String, ?world) {
        if (graphic == null) {
            graphic = AssetPaths.green_cube_v2__png;            
        }        

        super(x, y, z, graphic, world);
        color = FlxColor.RED;
        
        this.entity = "Player";
        this.iso_bounds.moves = true;
        this.iso_bounds.post_update = true;
    }
    
    public var speed:Float = 5;
    public var Movekey:Bool = false;
    override public function update(elapsed:Float) {
        #if windows
      if (FlxG.keys.anyPressed(['W', 'Up'])) {
            // this.iso_y = -Speed;
            this.iso_bounds.velocity.y = -speed;
            Movekey = true;
        } else if (FlxG.keys.anyPressed(['S', 'Down'])) {
            // this.iso_y = Speed;
            this.iso_bounds.velocity.y = speed;
            Movekey = true;
        } else if (FlxG.keys.anyJustReleased(['W', 'S', 'Up', 'Down'])) {
            this.iso_bounds.velocity.y = 0;

        }
        
        if (FlxG.keys.anyPressed(['A', 'Left'])) {
            // this.iso_x = -Speed;
            this.iso_bounds.velocity.x = -speed;
            Movekey = true;
        } else if (FlxG.keys.anyPressed(['D', 'Right'])) {
            // this.iso_x = Speed;
            this.iso_bounds.velocity.x = speed;
            Movekey = true;
        } else if (FlxG.keys.anyJustReleased(['A', 'D', 'Left', 'Right'])) {
            this.iso_bounds.velocity.x = 0;
        }
        
        if (FlxG.keys.justPressed.X) {
            // this.iso_z = -1;
            this.iso_bounds.velocity.z = -speed;
            Movekey = true;
        } else if (FlxG.keys.justPressed.Z) {
            // this.iso_z = 1;
            this.iso_bounds.velocity.z = speed;
            Movekey = true;
        } else {
            this.iso_bounds.velocity.z = 0;
        } 
        #end
        

        if (Movekey) {  
            Movekey = false;
            //this.ResetBounds();         
        }          
    }
}
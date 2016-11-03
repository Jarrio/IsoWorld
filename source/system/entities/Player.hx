package system.entities;

import flixel.graphics.FlxGraphic;
import system.entities.IsoSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import system.constants.Physics;

class Player extends IsoSprite {
    public function new(x:Float, y:Float, z:Float, ?graphic:String, ?world) {
        if (graphic == null) {
            graphic = AssetPaths.green_cube_v2__png;            
        }        

        super(x, y, z, graphic, world);
        color = FlxColor.RED;
        
        this.entity = "Player";
        this.iso_bounds.weight = 1;
        this.iso_bounds.moves = true; 
        this.iso_bounds.immovable = false;
        this.iso_bounds.post_update = true;
    }
    
    public var speed:Float = 10;
    public var Movekey:Bool = false;
    override public function update(elapsed:Float) {
        #if windows
        if (FlxG.keys.anyPressed(['W', 'Up'])) {
        // this.iso_y = -Speed;
            if (!this.iso_bounds.touching.front_y) { 
                this.iso_bounds.velocity.y = -speed;
            } else {
                 this.iso_bounds.velocity.y += speed;
            }
            
        } else if (FlxG.keys.anyPressed(['S', 'Down'])) {
        // this.iso_y = Speed;
            if (!this.iso_bounds.touching.back_y) { 
                this.iso_bounds.velocity.y = speed;
            } else {
                 this.iso_bounds.velocity.y -= speed;
            }
        } else {
            this.iso_bounds.velocity.y = 0;
        } 

        if (FlxG.keys.anyPressed(['A', 'Left'])) {
            // this.iso_x = -Speed;
            if (!this.iso_bounds.touching.back_x) { 
                this.iso_bounds.velocity.x = -speed;
            } else { 
                this.iso_bounds.velocity.x += speed;
            }

        } else if (FlxG.keys.anyPressed(['D', 'Right'])) {
        // this.iso_x = Speed;
            if(!this.iso_bounds.touching.front_x) {
                this.iso_bounds.velocity.x = speed;
            } else {
                this.iso_bounds.velocity.x -= speed;
            }

        } else {
            this.iso_bounds.velocity.x = 0;
        }
        
        if (FlxG.keys.pressed.X ) {
            // this.iso_z = -1;
            this.iso_bounds.velocity.z = -speed;
            Movekey = true;
        } else if (FlxG.keys.pressed.Z) {
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
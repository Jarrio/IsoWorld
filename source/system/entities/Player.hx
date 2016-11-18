package system.entities;

import flixel.graphics.FlxGraphic;
import system.entities.IsoSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import system.constants.Physics;

class Player extends IsoSprite {
    public var colliding:Bool = false;
    public function new(x:Float, y:Float, z:Float, ?graphic:String, ?world) {
        if (graphic == null) {
            graphic = AssetPaths.water_cube__png;            
        }        

        super(x, y, z, graphic, world);
        
        
        this.entity = "Player";
        this.iso_bounds.weight = 1;
        this.iso_bounds.moves = true; 
        this.iso_bounds.immovable = false;
        this.iso_bounds.post_update = true;
        this.iso_bounds.allow_gravity = true;
        this.iso_bounds.gravity.z = -50;      
    }
    

    public var speed:Float = 10;
    public var Movekey:Bool = false;
    override public function update(elapsed:Float) {
        #if windows

        // if (this.iso_bounds.touching.front_y) {
        //     this.iso_bounds.velocity.y += this.iso_bounds.width_y + this.iso_bounds.overlap_y;
        // }

        
        // if (this.iso_bounds.touching.back_x) {
        //     this.iso_bounds.velocity.x -= speed + -this.iso_bounds.overlap_x;
            
        // } 

        // if (this.iso_bounds.touching.front_x) {
        //     this.iso_bounds.velocity.x -= speed + -this.iso_bounds.overlap_x;
        // } 

        // if (this.iso_bounds.touching.bottom) {
        //     this.iso_bounds.velocity.z += speed - this.iso_bounds.overlap_z;
        // }

        // if (this.iso_bounds.touching.top) {
        //     this.iso_bounds.velocity.z -= speed + -this.iso_bounds.overlap_z;
        // }

        if (FlxG.keys.anyPressed(['W', 'Up'])) {
            this.iso_bounds.velocity.y = -speed;
        } else if (FlxG.keys.anyPressed(['S', 'Down'])) {
            this.iso_bounds.velocity.y = speed;
        } else {
            this.iso_bounds.velocity.y = 0;
        }
        
        if (FlxG.keys.anyPressed(['A', 'Left'])) {            
            this.iso_bounds.velocity.x = -speed;
        } else if (FlxG.keys.anyPressed(['D', 'Right'])) {
             this.iso_bounds.velocity.x = speed;
        } else {
            this.iso_bounds.velocity.x = 0;
        }
        
        if (FlxG.keys.pressed.X ) {
             this.iso_bounds.velocity.z = -5;
        } else if (FlxG.keys.pressed.Z) {
             this.iso_bounds.velocity.z = 5;
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
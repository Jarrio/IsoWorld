package system.entities;

import flixel.graphics.FlxGraphic;
import system.entities.IsoSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import system.constants.Physics;
import flixel.tweens.FlxTween;

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
        this.iso_bounds.check_collision.none = true;
        this.iso_bounds.check_collision.back_x = false;
        this.iso_bounds.check_collision.front_x = false;
        this.iso_bounds.check_collision.back_y = false;
        this.iso_bounds.check_collision.front_y = false;
        this.iso_bounds.check_collision.top = false;
        this.iso_bounds.check_collision.bottom = false;
        this.iso_bounds.check_collision.any = false;
        
        // this.iso_bounds.allow_gravity = true;
        this.iso_bounds.gravity.z = -150;      
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
        
        if (FlxG.keys.pressed.X) {
             this.iso_bounds.velocity.z = speed;
        } else if (FlxG.keys.pressed.Z) {
            this.iso_bounds.velocity.z = -speed;
        } else if (FlxG.keys.pressed.SPACE && this.iso_bounds.touching.bottom && !this.Movekey) {
            this.iso_bounds.velocity.z = 80;
            this.Movekey = true;
        } else {
            this.iso_bounds.velocity.z = 0;            
        }

        if (FlxG.keys.justReleased.SPACE) {
            this.Movekey = false;
        }

        #end
    }
}
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
            graphic = AssetPaths.green_cube_v2__png;            
        }        

        super(x, y, z, graphic, world);
        color = FlxColor.RED;
        
        this.entity = "Player";
        this.iso_bounds.weight = 1;
        this.iso_bounds.moves = true; 
        this.iso_bounds.immovable = false;
        this.iso_bounds.post_update = true;
        this.iso_bounds.allow_gravity = false;
        this.iso_bounds.gravity.z = 25;        
    }
    
    public var speed:Float = 10;
    public var Movekey:Bool = false;
    override public function update(elapsed:Float) {
        #if windows
        if (FlxG.keys.anyPressed(['W', 'Up'])) {
            this.iso_bounds.velocity.y = -speed;
        } else if (FlxG.keys.anyPressed(['S', 'Down'])) {
            this.iso_bounds.velocity.y = speed;
        } else if (FlxG.keys.anyPressed(['A', 'Left'])) {
            this.iso_bounds.velocity.x = -speed;
        } else if (FlxG.keys.anyPressed(['D', 'Right'])) {
            this.iso_bounds.velocity.x = speed;
        }
        
        if (FlxG.keys.pressed.X ) {
            this.iso_bounds.velocity.z = -speed;
        } else if (FlxG.keys.pressed.Z) {
            this.iso_bounds.velocity.z = speed;
        }
        #end

        if (Movekey) {  
            Movekey = false;
            //this.ResetBounds();         
        }          
    }
}
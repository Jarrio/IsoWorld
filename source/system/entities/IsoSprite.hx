package system.entities;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.system.debug.watch.Tracker.TrackerProfile;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import haxe.ds.Vector;
import hxmath.math.Vector2;
import hxmath.math.Vector3;

import system.entities.physics.Cube;
import system.entities.physics.Body;
import system.world.World;

class IsoSprite extends FlxSprite {
    
    public var iso_position:Vector3 = new Vector3(0, 0, 0);
    public var iso_bounds:Body;
    public var cube:Cube;
    public var z:Float = 0;
    
    public var iso_visited:Int = 0;
    public var iso_depth:Int = 0;

    public var world:World;

    //@optimise iso_sprites_behind no reason to store more sprites
    public var iso_sprites_behind:Array<IsoSprite> = new Array<IsoSprite>();

    public var anchor = new Vector2(0, 0);
    
    public var entity:String;
    
    public function new(?x:Float, ?y:Float, ?z:Float, ?graphic:String, ?world) {
        super();  

        if (graphic != null) {
            this.loadGraphic(graphic);
        }

        if (world != null) {
            this.world = world;
        }
        
        if (this.iso_bounds == null) {
            iso_bounds = new Body(this);
        }

        if (x != null && y != null && z != null) {
            iso_x = x;
            iso_y = y;
            iso_z = z;
        }

        this.offset.set(this.iso_bounds.center.x, this.iso_bounds.center.y);
        


        ResetIsoBounds();          

    }

    public var iso_x(get, set):Float;
    
    @:noCompletion
    public function get_iso_x() {
        return this.iso_position.x;
    }
    
    @:noCompletion
    public function set_iso_x(value:Float):Float {
        this.iso_position.x = FlxMath.roundDecimal(this.iso_position.x + value, 3);
        if (this.iso_bounds != null) {
            this.iso_bounds.reset = true;
        }
        return this.iso_position.x;
    }

    public var iso_y(get, set):Float;

    @:noCompletion
    public function get_iso_y():Float {
        return this.iso_position.y;
    }

    @:noCompletion
    public function set_iso_y(value:Float):Float {
        this.iso_position.y = FlxMath.roundDecimal(this.iso_position.y + value, 3);
        if (this.iso_bounds != null) {
            this.iso_bounds.reset = true;
        }
        return this.iso_position.y;
    }
    
    public var iso_z(get, set):Float;

    @:noCompletion
    public function get_iso_z():Float {
        return this.iso_position.z;
    }

    @:noCompletion
    public function set_iso_z(value:Float):Float {
        this.iso_position.z = FlxMath.roundDecimal(this.iso_position.z + value, 3);
        if (this.iso_bounds != null) {
            this.iso_bounds.reset = true;
        }        
        return this.iso_position.z;
    }    

    public function ResetIsoBounds() {


        this.iso_bounds.width_x = Math.round(Math.abs(this.width) * 0.5);
        this.iso_bounds.width_y = Math.round(Math.abs(this.width) * 0.5);
        this.iso_bounds.height  = Math.round(Math.abs(this.height) - (Math.abs(this.width) * 0.5));

        this.iso_bounds.x = this.iso_x + (this.iso_bounds.width_x * this.anchor.x) + (this.iso_bounds.width_x);
        this.iso_bounds.y = this.iso_y + (this.iso_bounds.half_width_y * this.anchor.x) - (this.iso_bounds.half_width_y);
        this.iso_bounds.z = this.iso_z - (Math.abs(this.height) * (1 - this.anchor.y)) + (Math.abs(this.width * 0.5));
 
    }

}
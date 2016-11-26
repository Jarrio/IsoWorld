package system.entities.physics;

import flixel.FlxG;
import flixel.math.FlxMath;
import hxmath.math.Vector3;
import system.constants.Physics.AllowCollisions;
import system.constants.Physics.Touching;
import system.constants.Physics.PreviousTouching;
import system.constants.Physics.Blocked;
import haxe.ds.Vector;
import system.entities.IsoSprite;
import system.constants.Physics;


class Body {

    public var sprite:IsoSprite;

    public var offset:Vector3 = new Vector3(0, 0, 0);

    public var center:Vector3 = new Vector3(0, 0, 0);

    public var position:Vector3 = new Vector3(0, 0, 0);

    public var previous = new Vector3(0, 0, 0);

    public var allow_gravity:Bool = false;
    
    public var gravity:Vector3 = new Vector3(0, 0, 0);

    public var velocity:Vector3 = new Vector3(0, 0, 0);

    public var new_velocity:Vector3 = new Vector3(0, 0, 0);
    
    public var speed:Float = 0;

    public var acceleration:Vector3 = new Vector3(0, 0, 0);

    public var drag:Vector3 = new Vector3(0, 0, 0);
    
    public var max_velocity:Vector3 = new Vector3(1000, 1000, 1000);

    public var bounce:Vector3 = new Vector3(0, 0, 0);

    public var max_delta:Vector3 = new Vector3(0, 0, 0);

    public var width_x:Float;

    public var width_y:Float;

    public var height:Float;

    public var half_width_x:Float;

    public var half_width_y:Float;    

    public var half_height:Float;    

    public var overlap_x:Float = 0;
 
    public var overlap_y:Float = 0;

    public var overlap_z:Float = 0;

    public var implanted:Bool = false; 

    public var delta:Vector3 = new Vector3(0, 0, 0);

    public var check_collision:AllowCollisions = new AllowCollisions();

    public var touching:Touching = new Touching();

    public var facing:Facing = Facing.None;

    public var pre_update:Bool = true;

    public var post_update:Bool = false;

    public var immovable:Bool = false;

    public var weight:Float = 1;
    

    /**
    * @property {wasTouching} - Previous touching values
    **/
    public var wasTouching:PreviousTouching = new PreviousTouching();

    /**
    * @property {blocked} - Specifies which directions the sprite is being blocked from moving
    **/
    public var blocked:Blocked = new Blocked();

    public var corners:Vector<Vector3> = new Vector<Vector3>(8);

    public var a_comparison:Vector<Float> = new Vector<Float>(3);
    public var b_comparison:Vector<Float> = new Vector<Float>(3);

    public var stage:Int = 0;

    public var moves:Bool = false;
    public var just_started:Bool = true;
    public var reset:Bool = true;

    public var delta_x:Float = 0;
    public var delta_y:Float = 0;
    public var delta_z:Float = 0;

    public var current_overlap:CollideSide = CollideSide.none;

    public function new(sprite:IsoSprite) {
        this.sprite = sprite;
        this.init();
    }

    public function init() {
        this.width_x = (this.sprite.width * 0.5);
        this.width_y = (this.sprite.width * 0.5);
        this.height  = (this.sprite.height) - (this.sprite.width * 0.5);

        this.half_width_x = (this.width_x * 0.5);
        this.half_width_y = (this.width_y * 0.5);
        this.half_height = (this.height * 0.5);

        this.center.set(this.x + (this.width_x), this.y + this.width_y, this.z + this.half_height);


        this.x_width = this.width_x / x_default;
        this.y_width = this.width_y / y_default;
        this.z_width = this.height / z_default;

        //this.position.set(sprite.IsoX(), sprite.IsoY(), sprite.IsoZ());
        //this.previous_position.set(this.position.x, this.position.y, this.position.z);
    }

    public var x_default:Float = 32;
    public var y_default:Float = 32;
    public var z_default:Float = 32;
    public var x_width:Float = 0;
    public var y_width:Float = 0;
    public var z_width:Float = 0;

    public function PreUpdate() {
        if (!this.pre_update) return;

        this.stage = 1;

        //Store and reset collision flags
        this.wasTouching.none = this.touching.none;
        this.wasTouching.top = this.touching.top;
        this.wasTouching.bottom = this.touching.bottom;
        this.wasTouching.back_x = this.touching.back_x;
        this.wasTouching.back_y = this.touching.back_y;
        this.wasTouching.front_x = this.touching.front_x;
        this.wasTouching.front_y = this.touching.front_y;

        this.touching.none = true;
        this.touching.top = false;
        this.touching.bottom = false;
        this.touching.back_x = false;
        this.touching.back_y = false;
        this.touching.front_x = false;
        this.touching.front_y = false;

        this.blocked.top = false;
        this.blocked.bottom = false;
        this.blocked.front_y = false;
        this.blocked.front_x = false;
        this.blocked.back_y = false;
        this.blocked.back_x = false;

        this.implanted = false;

        // this.current_overlap = CollideSide.none;
        
        
        // this.x = this.sprite.iso_x + ((this.width_x * -this.sprite.anchor.x) + this.width_x * 0.5) + this.offset.x;
        // this.y = this.sprite.iso_y + ((this.width_y * this.sprite.anchor.x) - this.width_y * 0.5) + this.offset.y;
        // this.z = this.sprite.iso_z - ((Math.abs((this.height * 0.5)) * (1 - this.sprite.anchor.y)));
        this.x = this.sprite.iso_x + this.x_width;
        this.y = this.sprite.iso_y + this.y_width;
        this.z = this.sprite.iso_z - this.z_width;

        
        // this.z = this.sprite.iso_z - (Math.abs(this.sprite.height * 0.5) * (1 - this.sprite.anchor.y)) + (Math.abs(this.sprite.width * 0.5)) + this.offset.z;        
                        
        if (this.reset || this.just_started) {
            this.previous.x = this.x;
            this.previous.y = this.y;
            this.previous.z = this.z;

            this.sprite.offset.set(this.center.x, this.center.y);
            // this.x = (this.sprite.iso_x - this.sprite.iso_y) * this.width_x;
            // this.y = (FlxG.height / 2) + (this.sprite.iso_x + this.sprite.iso_y - (this.sprite.iso_z * 2)) * (this.half_width_y);
            // this.z = (this.sprite.iso_z * 2) * (this.half_height);     
            if (this.just_started) this.just_started = false;
        }
        //------------------------------------------------
        // this.sprite.x = (this.x - this.y) * this.width_x;
        // this.sprite.y = (this.x + this.y - (this.z * 2)) * (this.half_width_y);
        // this.sprite.z = (this.z * 2) * (this.half_height);

        if (this.moves) {
            this.sprite.world.game.UpdateMotion(this);
            var new_x = FlxMath.roundDecimal(this.velocity.x * FlxG.elapsed, this.decimal);
            var new_y = FlxMath.roundDecimal(this.velocity.y * FlxG.elapsed, this.decimal);
            var new_z = FlxMath.roundDecimal(this.velocity.z * FlxG.elapsed, this.decimal);

            this.new_velocity.set(new_x, new_y, new_z);

            this.x += this.new_velocity.x;
            this.y += this.new_velocity.y;
            this.z += this.new_velocity.z;

            if (this.x != this.previous.x || this.y != this.previous.y || this.z != this.previous.z) {
                this.speed = Math.sqrt(this.velocity.x * this.velocity.x + this.velocity.y + this.velocity.z * this.velocity.z);
            }
        }        

        
        this.a_comparison[0] = this.front_x;
        this.a_comparison[1] = this.front_y;
        this.a_comparison[2] = this.top;

        this.b_comparison[0] = this.x;
        this.b_comparison[1] = this.y;
        this.b_comparison[2] = this.z;

        this.delta_x = this.get_delta_x();
        this.delta_y = this.get_delta_y();
        this.delta_z = this.get_delta_z();

        this.reset = false;
    }

    public function PostUpdate() {
        if (!this.post_update) return;
        if (this.stage == 2) return;

        this.stage = 2;

        if (this.reset) {
            this.previous.x = this.position.x;
            this.previous.y = this.position.y;
            this.previous.z = this.position.z;
        }
        
        if(this.abs_delta_x >= this.abs_delta_y && this.abs_delta_x >= this.abs_delta_z) {
            if (this.delta_x < 0) {
                this.facing = Facing.BackwardX;
            } else if (delta_x > 0) {
                this.facing = Facing.ForwardX;
            } 
        } else if (this.abs_delta_y >= this.abs_delta_x && this.abs_delta_y >= this.abs_delta_z) {
            if (this.delta_y < 0) {
                this.facing = Facing.ForwardY;
            } else if (delta_y > 0) {
                this.facing = Facing.BackwardY;
            }             
        } else {
            if (this.delta_z < 0) {
                this.facing = Facing.Down;
            } else {
                this.facing = Facing.Up;
            }
        }

        if(this.moves) {
            this.delta_x = this.get_delta_x();
            this.delta_y = this.get_delta_y();
            this.delta_z = this.get_delta_z();

            //delta x != exceed max_delta
            if (this.max_delta.x != 0 && this.delta_x != 0) {
                if (this.delta_x < 0 && this.delta_x < -this.max_delta.x) {
                    this.delta_x = -this.max_delta.x;
                } else if (this.delta_x > 0 && this.delta_x > this.max_delta.x) {
                    this.delta_x = this.max_delta.x;
                }
            }

            if (this.max_delta.y != 0 && this.delta_y != 0) {
                if (this.delta_y < 0 && this.delta_y < -this.max_delta.y) {
                    this.delta_y = -this.max_delta.y;
                } else if (this.delta_y > 0 && this.delta_y > this.max_delta.y) {
                    this.delta_y = this.max_delta.y;
                }
            }

            if (this.max_delta.z != 0 && this.delta_z != 0) {
                if (this.delta_z < 0 && this.delta_z < -this.max_delta.z) {
                    this.delta_z = -this.max_delta.z;
                } else if (this.delta_z > 0 && this.delta_z > this.max_delta.z) {
                    this.delta_z = this.max_delta.z;
                }
            }
 
            this.sprite.iso_x = this.delta_x;                        
            this.sprite.iso_y = this.delta_y;                        
            this.sprite.iso_z = this.delta_z;  

            //trace('this.delta_x: ${this.delta_x} | this.delta_y: ${this.delta_y} | this.delta_z: ${this.delta_z} ');                      
        }

        this.center.set(this.x + this.half_width_x, this.y + this.half_width_y, this.z + this.half_height);

        this.previous.x = this.position.x;
        this.previous.y = this.position.y;
        this.previous.z = this.position.z;

        this.reset = false;
    }
    /**
    * @method {GetCorners} - Return the 8 corners of the cube
    **/
    public function GetCorners():Vector<Vector3> {
        this.corners[0].set(this.x, this.y, this.z);
        this.corners[1].set(this.x, this.y, this.z + this.height);
        this.corners[2].set(this.x, this.y + this.width_y, this.z);
        this.corners[3].set(this.x, this.y + this.width_y, this.z + this.height);
        this.corners[4].set(this.x + this.width_x, this.y, this.z);
        this.corners[5].set(this.x + this.width_x, this.y, this.z + this.height);
        this.corners[6].set(this.x + this.width_x, this.y + this.width_y, this.z);
        this.corners[7].set(this.x + this.width_x, this.y + this.width_y, this.z + this.height);

        return this.corners;
    }

    /**
    * 
    **/
    
    public var abs_delta_x(get, null):Float;
    @:noCompletion
    public function get_abs_delta_x():Float {
        return (this.delta_x > 0 ? this.delta_x : -this.delta_x);
    }

    public var abs_delta_y(get, null):Float;
    @:noCompletion
    public function get_abs_delta_y():Float {
        return (this.delta_y > 0 ? this.delta_y : -this.delta_y);
    }

    public var abs_delta_z(get, null):Float;
    @:noCompletion
    public function get_abs_delta_z():Float {
        return (this.delta_z > 0 ? this.delta_z : -this.delta_z);
    } 

    public function get_delta_x():Float {
        return this.position.x - this.previous.x;
    }

    public function get_delta_y():Float {
        return this.position.y - this.previous.y;
    }

    public function get_delta_z():Float {
        return this.position.z - this.previous.z;
    }    

    public var decimal:Int = 3;
    public var top(get, null):Float;
    
    @:noCompletion
    public function get_top():Float {           
        return FlxMath.roundDecimal(this.position.z + this.z_width, decimal);
        // return FlxMath.roundDecimal(this.position.z + this.height, decimal);
    }

    public var front_x(get, null):Float;

    @:noCompletion
    public function get_front_x():Float {
        return FlxMath.roundDecimal(this.position.x + this.x_width, decimal);
        // return FlxMath.roundDecimal(this.position.x + this.width_x, decimal);
    }

    public var front_y(get, null):Float;

    @:noCompletion
    public function get_front_y():Float {
        return FlxMath.roundDecimal(this.position.y + this.y_width, decimal);
        // return FlxMath.roundDecimal(this.position.y + this.y_width, decimal);
    }                


    public var x(get, set):Float;
    
    @:noCompletion
    public function set_x(value:Float):Float {                   
        return this.position.x = FlxMath.roundDecimal(value, decimal);
    }
    
    @:noCompletion
    public function get_x():Float {                   
        return this.position.x;
    }

    public var y(get, set):Float ;

    @:noCompletion
    public function set_y(value:Float):Float {           
        return this.position.y = FlxMath.roundDecimal(value, decimal);
    }

    @:noCompletion
    public function get_y():Float {           
        return this.position.y;
    }

    public var z(get, set):Float;

    @:noCompletion
    public function set_z(value:Float):Float {
        return this.position.z = FlxMath.roundDecimal(value, decimal);
    }     

    @:noCompletion
    public function get_z():Float {
        return this.position.z;
    }     
}

enum Facing {
    None;
    BackwardX;
    BackwardY;

    ForwardX;
    ForwardY;

    Up;
    Down;
}


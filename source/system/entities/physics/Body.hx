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


class Body {
    /**
    * @property {sprite} - Reference to the parent sprite
    **/
    public var sprite:IsoSprite;

    /**
    * @property {offset} - The offset from the sprites default x/y/z
    **/
    public var offset:Vector3 = new Vector3(0, 0, 0);

    /**
    * @property {position} - Isometric coordinates of the sprite
    **/
    public var position:Vector3 = new Vector3(0, 0, 0);

    /**
    * @property {previous_position} - The last position the sprite was on
    **/
    public var previous_position = new Vector3(0, 0, 0);

    /**
    * @property {width_x} - The calculated x width
    **/
    public var width_x:Float;

    /**
    * @property {width_y} - The calculated y width
    **/
    public var width_y:Float;

    /**
    * @property {height} - The calculated height
    **/
    public var height:Float;

    /**
    * @property {half_width_x} - Half of the X width
    **/
    public var half_width_x:Float;

    /**
    * @property {half_width_y} - Half of the Y width
    **/
    public var half_width_y:Float;    

    /**
    * @property {half_height} - Half of the height
    **/
    public var half_height:Float;    


    /**
    * @property {overlap_x} - When colliding with another entity this stores the overlap value
    **/    
    public var overlap_x:Float = 0;

    /**
    * @property {overlap_z} - When colliding with another entity this stores the overlap value
    **/    
    public var overlap_y:Float = 0;

    /**
    * @property {overlap_z} - When colliding with another entity this stores the overlap value
    **/    
    public var overlap_z:Float = 0;

    /**
    * @property {embedded} - If a body is overlapping with another body but neither are moving
    **/
    public var embedded:Bool = false; 

    /**     
    * @property {check_collision} - Specifies which directions collisions are processed for 
    **/
    public var check_collision:AllowCollisions = new AllowCollisions();

    /**
    * @property {touching} - Specifies which sides the sprite is being touched
    **/
    public var touching:Touching = new Touching();

    /**
    * @property {wasTouching} - Previous touching values
    **/
    public var wasTouching:PreviousTouching = new PreviousTouching();

    /**
    * @property {blocked} - Specifies which directions the sprite is being blocked from moving
    **/
    public var blocked:Blocked = new Blocked();

    /**
    * @property {corners} - The 8 Corners of the bounding cube
    **/
    public var corners:Vector<Vector3> = new Vector<Vector3>(8);

    /**
    * @property {moves} - Need to know if this sprite moves for optimising the sorting
    **/
    public var moves:Bool = true;

    public var moved:Bool = true;

    public var a_comparison:Vector<Float> = new Vector<Float>(3);
    public var b_comparison:Vector<Float> = new Vector<Float>(3);


    public function new(sprite:IsoSprite) {
        this.sprite = sprite;
    }

    public function init() {
        this.width_x = (this.sprite.width * 0.5);
        this.width_y = (this.sprite.width * 0.5);
        this.height  = (this.sprite.height) - (this.sprite.width * 0.5);

        this.half_width_x = (this.width_x * 0.5);
        this.half_width_y = (this.width_y * 0.5);
        this.half_height = (this.height * 0.5);


        

        //this.position.set(sprite.IsoX(), sprite.IsoY(), sprite.IsoZ());
        //this.previous_position.set(this.position.x, this.position.y, this.position.z);
    }

    public function PreUpdate() {
        //Store and reset collision flags
        this.wasTouching.none = this.touching.none;
        this.wasTouching.up = this.touching.up;
        this.wasTouching.down = this.touching.down;
        this.wasTouching.backX = this.touching.backX;
        this.wasTouching.backY = this.touching.backY;
        this.wasTouching.frontX = this.touching.frontX;
        this.wasTouching.frontY = this.touching.frontY;

        this.touching.none = true;
        this.touching.up = false;
        this.touching.down = false;
        this.touching.backX = false;
        this.touching.backY = false;
        this.touching.frontX = false;
        this.touching.frontY = false;

        this.blocked.up = false;
        this.blocked.down = false;
        this.blocked.frontY = false;
        this.blocked.frontX = false;
        this.blocked.backY = false;
        this.blocked.backX = false;

        this.embedded = false;

        //------------------------------------------------
        // this.sprite.x = (this._x - this._y) * this.width_x;
        // this.sprite.y = (this._x + this._y - (this._z * 2)) * (this.half_width_y);
        // this.sprite.z = (this._z * 2) * (this.half_height);
        
        this.sprite.x = (FlxG.width / 2) + (this.sprite.iso_x - this.sprite.iso_y) * this.width_x;
        this.sprite.y = (FlxG.height / 2) + (this.sprite.iso_x + this.sprite.iso_y - (this.sprite.iso_z * 2)) * (this.half_width_y);
        this.sprite.z = (this.sprite.iso_z * 2) * (this.half_height);
        
        this.a_comparison[0] = this.front_x;
        this.a_comparison[1] = this.front_y;
        this.a_comparison[2] = this.top;

        this.b_comparison[0] = this._x;
        this.b_comparison[1] = this._y;
        this.b_comparison[2] = this._z;

        //this.moved = false;
        //------------------------------------------------
        // this.x = (this.IsoX() - this.IsoY()) * this.iso_bounds.width_x;
        // this.y = (this.IsoX() + this.IsoY() - (this.IsoZ() * 2)) * (this.iso_bounds.half_width_y);
        // this.z = (this.IsoZ() * 2) * (this.iso_bounds.half_height);

        // this.position.x = this.sprite.IsoX() + ((this.width_x * -this.sprite.anchor.x) + this.width_x * 0.5) + this.offset.x;
        // this.position.y = this.sprite.IsoY() + ((this.width_y * this.sprite.anchor.x) - this.width_y * 0.5) + this.offset.y;
        // this.position.z = this.sprite.IsoZ() - (Math.abs(this.sprite.height) * (1 - this.sprite.anchor.y)) + (Math.abs(this.sprite.width * 0.5)) + this.offset.z;

        //this.updateBounds();
        // this.position.x = this.sprite.IsoX() + (this.width_x * 0.5);
        // this.position.y = this.sprite.IsoY() + (this.width_y * 0.5);
        // this.position.x = (this.sprite.IsoX() - this.sprite.IsoY()) * this.width_x;
        // this.position.y = (this.sprite.IsoX() + this.sprite.IsoY() - (this.sprite.IsoZ() * 2)) * this.half_height;         
        // this.position.z = this.sprite.IsoZ() - (Math.abs(this.sprite.height)) + (Math.abs(this.sprite.width * 0.5));
    }

    /**
    * @method {GetCorners} - Return the 8 corners of the cube
    **/
    public function GetCorners():Vector<Vector3> {
        this.corners[0].set(this._x, this._y, this._z);
        this.corners[1].set(this._x, this._y, this._z + this.height);
        this.corners[2].set(this._x, this._y + this.width_y, this._z);
        this.corners[3].set(this._x, this._y + this.width_y, this._z + this.height);
        this.corners[4].set(this._x + this.width_x, this._y, this._z);
        this.corners[5].set(this._x + this.width_x, this._y, this._z + this.height);
        this.corners[6].set(this._x + this.width_x, this._y + this.width_y, this._z);
        this.corners[7].set(this._x + this.width_x, this._y + this.width_y, this._z + this.height);

        return this.corners;
    }

    /**
    * 
    **/
    public var decimal:Int = 2;

    public var top(get, null):Float;

    @:noCompletion
    public function get_top():Float {           
        return FlxMath.roundDecimal(this.position.z + (this.height), decimal);
    }

    public var front_x(get, null):Float;

    @:noCompletion
    public function get_front_x():Float {
        return FlxMath.roundDecimal(this.position.x + (this.width_x), decimal);
    }

    public var front_y(get, null):Float;

    @:noCompletion
    public function get_front_y():Float {
        return FlxMath.roundDecimal(this.position.y + (this.width_y), decimal);
    }                


    public var _x(get, set):Float;
    
    @:noCompletion
    public function set__x(value:Float):Float {                   
        return this.position.x = FlxMath.roundDecimal(value, decimal);
    }
    
    @:noCompletion
    public function get__x():Float {                   
        return this.position.x;
    }

    public var _y(get, set):Float ;

    @:noCompletion
    public function set__y(value:Float):Float {           
        return this.position.y = FlxMath.roundDecimal(value, decimal);
    }

    @:noCompletion
    public function get__y():Float {           
        return this.position.y;
    }

    public var _z(get, set):Float;

    @:noCompletion
    public function set__z(value:Float):Float {
        return this.position.z = FlxMath.roundDecimal(value, decimal);
    }     

    @:noCompletion
    public function get__z():Float {
        return this.position.z;
    }     
}
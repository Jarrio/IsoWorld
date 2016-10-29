package system.entities.physics;

import flixel.math.FlxMath;

class Cube extends Body {

    public var x:Float = 0;
    public var y:Float = 0;
    public var z:Float = 0;

    public function new(sprite:IsoSprite) {
        super(sprite);
        this.init();
    }

    public function BackX(?value:Float):Float {
        if (value != null) {
            if (value >= this.front_x) {
                this.width_x = 0;
            } else {
                this.width_x = (this.front_x - value);
            }
            
            this.x = value;
        }
        
        return this.x;
    }

    public function BackY(?value:Float):Float {
        if (value != null) {
            if (value >= this.front_y) {
                this.width_y = 0;
            } else {
                this.width_y = (this.front_y - value);
            }
            this.y = value;
        }
        
        return this.y;
    }

    public function CubeBottom(?value:Float):Float {
        if (value != null) {
            if (value >= this.top) {
                this.height = 0;
            } else {
                this.height = this.top - value;
            }
            this.z = value;
        }
        
        return this.z;
    }

    public function CubeTop(?value:Float):Float {
        if (value != null) {
            if (value >= this.z) {
                this.height = 0;
            } else {
                this.height = value - this.z;
            }
        }
        
        return this.z + this.height;
    }

    public function CubeFrontX(?value:Float):Float {
        if (value != null) {
            if (value <= this.x) {
                this.width_x = 0;
            } else {
                this.width_x = (value - this.x);
            }
        }
        
        return this.x + this.width_x;
    }            

    public function CubeFrontY(?value:Float):Float {
        if (value != null) {
            if (value <= this.y) {
                this.width_y = 0;
            } else {
                this.width_y = (value - this.y);
            }
        }
        
        return this.y + this.width_y;
    }

    
}
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

    public var volume(get, null):Float;

    public function get_volume():Float {
        return this.width_x * this.width_y * this.height;
    }

    public function contains(cube:Cube, x:Float, y:Float, z:Float):Bool {
        if (cube.width_x <= 0 || cube.width_y <= 0 || cube.height <= 0) {
            return false;
        }

        return (x >= cube._x && x <= cube.front_x && y >= cube._y && y <= cube.front_y && z >= cube._z && z <= cube.top);
    }
    
    public function containsCube(a:Cube, b:Cube):Bool {
        if (a.volume > b.volume) {
            return false;
        }

        return (a._x >= b._x && a._y >= b._y && a._z >= b._z && a.front_x <= b.front_y && a.front_y <= b.front_y && a.top <= b.top);
    }
    
    public function intersects(a:Cube, b:Cube):Bool {
        if (a.width_x <= 0 || a.width_y <= 0 || a.height <= 0 || b.width_x <= 0 || b.width_y <= 0 || b.height <= 0) {
            return false;
        }

        return !(a.front_x < b._x || a.front_y < b._y || a._x > b.front_x || a._y > b.front_y || a._z > b.top || a.top < b._z);
    }
}
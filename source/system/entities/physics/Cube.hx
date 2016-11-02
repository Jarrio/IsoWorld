package system.entities.physics;

import flixel.math.FlxMath;

class Cube {

    public var body:Body;
    public var x:Float = 0;
    public var y:Float = 0;
    public var z:Float = 0;

    public function new(_body:Body) {
        this.body = _body;
    }

    public function BackX(?value:Float):Float {
        if (value != null) {
            if (value >= this.body.front_x) {
                this.body.width_x = 0;
            } else {
                this.body.width_x = (this.body.front_x - value);
            }
            
            this.x = value;
        }
        
        return this.x;
    }

    public function BackY(?value:Float):Float {
        if (value != null) {
            if (value >= this.body.front_y) {
                this.body.width_y = 0;
            } else {
                this.body.width_y = (this.body.front_y - value);
            }
            this.y = value;
        }
        
        return this.y;
    }

    public function CubeBottom(?value:Float):Float {
        if (value != null) {
            if (value >= this.body.top) {
                this.body.height = 0;
            } else {
                this.body.height = this.body.top - value;
            }
            this.z = value;
        }
        
        return this.z;
    }

    public function CubeTop(?value:Float):Float {
        if (value != null) {
            if (value >= this.z) {
                this.body.height = 0;
            } else {
                this.body.height = value - this.z;
            }
        }
        
        return this.z + this.body.height;
    }

    public function CubeFrontX(?value:Float):Float {
        if (value != null) {
            if (value <= this.x) {
                this.body.width_x = 0;
            } else {
                this.body.width_x = (value - this.x);
            }
        }
        
        return this.x + this.body.width_x;
    }            

    public function CubeFrontY(?value:Float):Float {
        if (value != null) {
            if (value <= this.y) {
                this.body.width_y = 0;
            } else {
                this.body.width_y = (value - this.y);
            }
        }
        
        return this.y + this.body.width_y;
    }

    public var volume(get, null):Float;

    public function get_volume():Float {
        return this.body.width_x * this.body.width_y * this.body.height;
    }

    public function contains(cube:Cube, x:Float, y:Float, z:Float):Bool {
        if (cube.body.width_x <= 0 || cube.body.width_y <= 0 || cube.body.height <= 0) {
            return false;
        }

        return (x >= cube.body.x && x <= cube.body.front_x && y >= cube.body.y && y <= cube.body.front_y && z >= cube.body.z && z <= cube.body.top);
    }
    
    public function containsCube(a:Cube, b:Cube):Bool {
        if (a.volume > b.volume) {
            return false;
        }

        return (a.body.x >= b.body.x && a.body.y >= b.body.y && a.body.z >= b.body.z && a.body.front_x <= b.body.front_y && a.body.front_y <= b.body.front_y && a.body.top <= b.body.top);
    }
    
    public function intersects(a:Cube, b:Cube):Bool {
        if (a.body.width_x <= 0 || a.body.width_y <= 0 || a.body.height <= 0 || b.body.width_x <= 0 || b.body.width_y <= 0 || b.body.height <= 0) {
            return false;
        }

        return !(a.body.front_x < b.body.x || a.body.front_y < b.body.y || a.body.x > b.body.front_x || a.body.y > b.body.front_y || a.body.z > b.body.top || a.body.top < b.body.z);
    }
}
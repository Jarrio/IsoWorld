package system.world;

import flixel.FlxG;
import flixel.math.FlxMath;
import system.entities.physics.Body;
import hxmath.math.Vector3;
import flixel.system.FlxQuadTree;


class World {

    public var gravity:Vector3 = new Vector3(100, 50, 0);
    public var drag:Float = 0;

    public var decimal:Int = 3;

    public function new() {
    }

    public function intersects(a:Body, b:Body):Bool {
        if (a.front_x <= b._x) {
            return false;
        }

        if (a.front_y <= b._y) {
            return false;
        }

        if (a._x >= b.front_x) {
            return false;
        }

        if (a._y >= b.front_y) {
            return false;
        }

        if (a.top <= b.top) {
            return false;
        }                                

        if (a._z >= b.top) {
            return false;
        }        

        return true;
    }

    public function UpdateMotion(body:Body):Void {
        body.velocity.x = this.ComputeVelocity(Axis.x, body, body.velocity.x, body.acceleration.x, body.drag.x, body.max_velocity.x);
        body.velocity.y = this.ComputeVelocity(Axis.y, body, body.velocity.y, body.acceleration.y, body.drag.y, body.max_velocity.y);
        body.velocity.z = this.ComputeVelocity(Axis.z, body, body.velocity.z, body.acceleration.z, body.drag.z, body.max_velocity.z);

    }

    public function ComputeVelocity(axis:Axis, body:Body, velocity:Float, ?acceleration:Float, ?drag:Float, max:Float = 1000):Float {

        if (body.allow_gravity) {
            if (axis == Axis.x) {
                velocity += (this.gravity.x + body.gravity.x) * FlxG.elapsed;
            } else if (axis == Axis.y) {
                velocity += (this.gravity.y + body.gravity.y) * FlxG.elapsed;
            } else if (axis == Axis.z) {
                velocity += (this.gravity.z + body.gravity.z) * FlxG.elapsed;
            } 
        }

        if (acceleration > 0) {
            velocity += acceleration * FlxG.elapsed;
        } else if(drag > 0) {
            this.drag = drag * FlxG.elapsed;

            if (velocity - this.drag > 0) {
                velocity -= this.drag;
            } else if (velocity + this.drag < 0) {
                velocity += this.drag;
            } else {
                velocity = 0;
            }
        }

        if (velocity > max) {
            velocity = max;
        } else if (velocity < -max) {
            velocity = -max;
        } 

        return FlxMath.roundDecimal(velocity, this.decimal);
    }

    public var overlap:Float;
    public var max_overlap:Float;
    public var overlap_bias:Int = 4;
    
    public var a_overlap_velocity:Float;
    public var b_overlap_velocity:Float;

    public function SeperateX(a:Body, b:Body, overlapOnly:Bool):Bool {
        if(a.immovable && b.immovable) return false;

        this.overlap = 0;

        if (this.intersects(a, b)) {
            this.max_overlap = Math.abs(a.delta.x) + Math.abs(b.delta.x) + this.overlap_bias;

            if (a.delta.x == 0 && b.delta.x == 0) {
                a.implanted = true;
                b.implanted = true;                
            } else if (a.delta.x > b.delta.x) {
                this.overlap = a.front_x - b._x;                
                if (this.overlap > this.max_overlap || a.check_collision.front_x == false || b.check_collision.back_x == false) {
                    trace('max: ${this.max_overlap} | overlap: ${-this.overlap}');
                    this.overlap = 0;
                } else {
                    
                    a.touching.none = false;
                    a.touching.front_x = true;

                    b.touching.none = false;
                    b.touching.back_x = true;
                }
            } else if (a.delta.x < b.delta.x) {
                
                this.overlap = a._x - b.width_x - b._x;
                
                if ((-this.overlap > this.max_overlap) || a.check_collision.back_x == false || b.check_collision.front_x == false) {
                    this.overlap = 0;
                } else {
                    a.touching.none = false;
                    a.touching.back_x = true;

                    b.touching.none = false;
                    b.touching.front_x = true;                    
                }
            }
        }

        if (this.overlap != 0) {
            a.overlap_x = this.overlap;
            b.overlap_x = this.overlap;

            if (overlapOnly) {
                return true;
            }

            this.a_overlap_velocity = a.velocity.x;
            this.b_overlap_velocity = b.velocity.x;

            if (!a.immovable && !b.immovable) {
                
                this.overlap *= 0.5;

                a._x = a._x - this.overlap;
                b._x += this.overlap;

                var new_velocity_a = (this.b_overlap_velocity * this.b_overlap_velocity * b.weight) / a.weight * ((this.b_overlap_velocity > 0) ? 1 : -1);
                var new_velocity_b = (this.a_overlap_velocity * this.a_overlap_velocity * a.weight) / b.weight * ((this.a_overlap_velocity > 0) ? 1 : -1);
                var average = (new_velocity_a + new_velocity_b) * 0.5;
                
                new_velocity_a -= average;
                new_velocity_b -= average;

                a.velocity.x = FlxMath.roundDecimal(average + new_velocity_a * a.bounce.x, this.decimal);
                b.velocity.x = FlxMath.roundDecimal(average + new_velocity_b * b.bounce.x, this.decimal);                
            } else if (!a.immovable) {
                a._x = a._x - this.overlap;
                a.velocity.x = FlxMath.roundDecimal(this.b_overlap_velocity - this.a_overlap_velocity * a.bounce.x, this.decimal);
            } else if (!b.immovable) {
                b._x += this.overlap;
                b.velocity.x = FlxMath.roundDecimal(this.a_overlap_velocity - this.b_overlap_velocity * b.bounce.x, this.decimal);
            } 

            return true;
        }

        return false; 
    }
}

enum Axis {
    none;
    x;
    y;
    z;
}
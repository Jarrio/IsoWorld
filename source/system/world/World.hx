package system.world;

import flixel.FlxG;
import flixel.math.FlxMath;
import system.entities.physics.Body;
import hxmath.math.Vector3;
import system.constants.Physics;
import system.entities.IsoSprite;


class World {

    public var gravity:Vector3 = new Vector3(0, 0, -100);
    public var drag:Float = 0;
    public var total:Int;

    public var decimal:Int = 3;

    public function new() {
    }

    public function intersects(a:Body, b:Body):Bool {

        // var a_max = a.a_comparison;
        // var b_min = b.b_comparison;
        var padding = 0;
        var a_min_max_x = (a.x + padding < b.front_x - padding);
        var a_max_min_x = (a.front_x + padding > b.x - padding);

        var a_min_max_y = (a.y + padding < b.front_y - padding);
        var a_max_min_y = (a.front_y + padding > b.y - padding);

        var a_min_max_z = (a.z + padding < b.top - padding);
        var a_max_min_z = (a.top + padding > b.z - padding);

        if (a_min_max_z && a_max_min_z) {
            if (a_min_max_x && a_max_min_x) {
                if (a_min_max_y && a_max_min_y) {
                    return true;
                }
            }
        }

        return false;

        if (a.x + padding < b.front_x - padding) {
            return false;
        }

        if (a.front_x + padding < b.x - padding) {
            return false;
        }
            
        if (a.y + padding > b.front_y - padding) {
            return false;
        }
        
        if (a.front_y + padding < b.y - padding) {
            return false;
        }


        if (a.z + padding > b.top - padding) {
            return false;   
        }
        
        if (a.top + padding < b.z - padding) {
            return false;
        }
        trace("True");
        return true;        
         

        // if (a.front_x <= b.x) {
        //     return false; 
        // }

        // if (a.x >= b.front_x) {
        //     return false; 
        // }

        // if (a.front_y <= b.y) {
        //     return false; 
        // }

        // if (a.y >= b.front_y) {
        //     return false; 
        // }

        // if (a.top <= b.z) {
        //     return false;
        // }                                

        // if (a.z >= b.top) {
        //     return false;
        // }        

        // return true;

        // if (a.x >= b.front_x) {
        //     return false;
        // }

        // if (b.x >= a.front_x) {
        //     return false;
        // }

        // if (a.y >= b.front_y) {
        //     return false;
        // }

        // if (b.y >= a.front_y) {
        //     return false;
        // }

        // if (a.z >= b.top) {
        //     return false;
        // }

        // if (b.z >= a.top) {
        //     return false;
        // }

        // return true;
        // return !(a.x >= b.front_x || b.x >= a.front_x) && !(a.y >= b.front_y || b.y >= a.front_y) && !(a.z >= b.top || b.z >= a.top);
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
//        trace(FlxMath.roundDecimal(velocity, this.decimal));
        return FlxMath.roundDecimal(velocity, this.decimal);
    }



    public var overlap:Float;
    public var max_overlap:Float;

    public var result:Bool;
    
    public var a_overlap_velocity:Float;
    public var b_overlap_velocity:Float;

    public function Collide(a:IsoSprite, b:IsoSprite):Bool {
        this.result = false;
        this.total = 0;

        this.CollideSprites(a, b, false);
        return (this.total > 0);
    }

    public function CollideHandler(a:Dynamic, ?b:IsoSprite, overlap:Bool):Void {
        if (Type.getClassName(a) == "FlxTypedSpriteGroup" && b == null) {
            //collide vs self
        }

        if (Type.getClass(a) == IsoSprite) {

        }
    }

    public function CollideSprites(a:IsoSprite, b:IsoSprite, overlap:Bool):Bool {
        if (a.iso_bounds == null || b.iso_bounds == null) {
            return false;
        }

        if(this.Seperate(a.iso_bounds, b.iso_bounds, overlap)) {
            this.total++;
//            trace("Collided");
        }

        return true;
    }

    public function Seperate(a:Body, b:Body, overlap:Bool):Bool {
        if (this.intersects(a, b) == false) return false;

        this.overlap = 0;

        var az_gravity = Math.abs(this.gravity.z + a.gravity.z);
        var ax_gravity = Math.abs(this.gravity.x + a.gravity.x);
        var ay_gravity = Math.abs(this.gravity.y + a.gravity.y);


        var check_x = this.SeperateX(a, b, overlap);
        var check_y = this.SeperateY(a, b, overlap);
        var check_z = this.SeperateZ(a, b, overlap);

        //    this.result = (check_x & check_y) | (check_y & check_z) | (check_z & check_x);
            // this.result = check_x ? (check_y || check_z) : (check_y && check_z);
        // if ((check_x && check_y) || (check_y && check_z) || (check_x && check_z)) {
        //     this.result = true;
        // }

        if (az_gravity < ax_gravity || az_gravity < ay_gravity) {
            if (check_x && check_z) {
                // trace("1SeperateX == true");
                return true;                
            }

            if (check_y && check_z) {
                // trace("1SeperateY == true");                
                return true;                    
            }

            if (check_z) {
                // trace("1SeperateZ == true");
                return true;
            }
            return false;
        } else {

            if (check_z) {
                return true;
            }

            if (check_x && check_z) {
                // trace("2SeperateX == true");
                return true;
            }

            if (check_y && check_z) {
                // trace("3SeperateY == true");
                return true;                                
            }

            // trace("Seperate == false");
        }

        return false;
    }

    public var new_velocity_a:Float;
    public var new_velocity_b:Float;
    public var average:Float;
    
    public var overlap_bias:Float = 1;
    public var min_overlap:Float;

    public function SeperateX(a:Body, b:Body, overlap:Bool):Bool {
        if(a.immovable && b.immovable) return false;

        this.overlap = 0;

        if (this.intersects(a, b)) {
            this.max_overlap = FlxMath.roundDecimal(a.abs_delta_x + b.abs_delta_x + this.overlap_bias, this.decimal);

            if (a.delta_x == 0 && b.delta_x == 0) {
                a.implanted = true;
                b.implanted = true;                
            } else if (a.delta_x > b.delta_x) {
                this.overlap = FlxMath.roundDecimal((a.x) - (b.x), this.decimal);

                
                if ((this.overlap > this.max_overlap) || !a.check_collision.front_x || !b.check_collision.back_x) {
                    // trace('X: Failed - (A>B) | max: ${this.max_overlap} | ${this.overlap}');    
                    // FlxG.watch.addQuick("X (A>B): Failed", true);
                    // FlxG.watch.addQuick("X (A>B): Worked", false);                                                          
                    this.overlap = 0;
                } else {
                    // FlxG.watch.addQuick("X (A>B): Failed", false);
                    // FlxG.watch.addQuick("X (A>B): Worked", true);  

                    // trace('X: Worked - (A>B) | max: ${this.max_overlap} | ${this.overlap}');    
                    a.touching.none = false;
                    a.touching.front_x = true;
                    a.current_overlap = CollideSide.front_x; 

                    b.touching.none = false;
                    b.touching.back_x = true;
                    b.current_overlap = CollideSide.back_x;
                }

                // trace('0 - (A>B) | max: ${this.max_overlap} | ${this.overlap}');                     
            } else if (a.delta_x < b.delta_x) {
                //var calc_x = (a.x - b.width_x - b.x);
                var calc_x = (b.front_x - b.width_x) - a.x;
                this.overlap = FlxMath.roundDecimal(calc_x, this.decimal);
                
                if ((-this.overlap > this.max_overlap) || !a.check_collision.back_x || !b.check_collision.front_x) {      
                    // trace('X: Failed - (A<B) | max: ${this.max_overlap} | ${-this.overlap}');     
                    // FlxG.watch.addQuick("X (A<B): Failed", true);
                    // FlxG.watch.addQuick("X (A<B): Worked", false);                                                          
                    this.overlap = 0;
                } else {
                    // FlxG.watch.addQuick("X (A<B): Failed", false);
                    // FlxG.watch.addQuick("X (A<B): Worked", true);  


                    // trace('X: Worked - (A<B) | max: ${this.max_overlap} | ${-this.overlap}');  
                                    
                    a.touching.none = false;
                    a.touching.back_x = true;
                    a.current_overlap = CollideSide.back_x;  

                    b.touching.none = false;
                    b.touching.front_x = true;      
                    b.current_overlap = CollideSide.front_x;        
                }

                // trace('End - (A<B) | max: ${this.max_overlap} | ${this.overlap}');
            }
        }

        if (this.overlap != 0) {        
            a.overlap_x = this.overlap;
            b.overlap_x = this.overlap;

            if (overlap) {
                return true;
            }

            this.a_overlap_velocity = a.velocity.x;
            this.b_overlap_velocity = b.velocity.x;

            if (!a.immovable && !b.immovable) {
                this.overlap *= 0.5;

                a.x = a.x - this.overlap;
                b.x += this.overlap;

                this.new_velocity_a = (this.b_overlap_velocity * this.b_overlap_velocity * b.weight) / a.weight * ((this.b_overlap_velocity > 0) ? 1 : -1);
                this.new_velocity_b = (this.a_overlap_velocity * this.a_overlap_velocity * a.weight) / b.weight * ((this.a_overlap_velocity > 0) ? 1 : -1);
                this.average = (this.new_velocity_a + new_velocity_b) * 0.5;
                
                this.new_velocity_a -= this.average;
                this.new_velocity_b -= this.average;

                a.velocity.x = FlxMath.roundDecimal(this.average + this.new_velocity_a * a.bounce.x, this.decimal);
                b.velocity.x = FlxMath.roundDecimal(this.average + this.new_velocity_b * b.bounce.x, this.decimal);                
            } else if (!a.immovable) {
                a.x = a.x - this.overlap;
                a.velocity.x = FlxMath.roundDecimal(this.b_overlap_velocity - this.a_overlap_velocity * a.bounce.x, this.decimal);
            } else if (!b.immovable) {
                b.x += this.overlap;
                b.velocity.x = FlxMath.roundDecimal(this.a_overlap_velocity - this.b_overlap_velocity * b.bounce.x, this.decimal);
            } 

            return true;
        }

        return false; 
    }

    public function SeperateY(a:Body, b:Body, overlap:Bool):Bool {
        if(a.immovable && b.immovable) return false;

        this.overlap = 0;

        if (this.intersects(a, b)) {
            // this.max_overlap = Math.abs(a.delta_y) + Math.abs(b.delta_y) + this.overlap_bias;
            this.max_overlap = FlxMath.roundDecimal(a.abs_delta_y + b.abs_delta_y + this.overlap_bias, this.decimal);
            this.min_overlap = -this.max_overlap;

            if (a.delta_y == 0 && b.delta_y == 0) {
                a.implanted = true;
                b.implanted = true;                
            } else if (a.delta_y > b.delta_y) {
                // this.overlap = (a.front_y - b.y) - a.width_y;
                // this.overlap = FlxMath.roundDecimal((a.front_x - a.width_x) - b.x, this.decimal);
                this.overlap = FlxMath.roundDecimal((a.y) - (b.y), this.decimal);
                           
                if ((this.overlap > this.max_overlap) || !a.check_collision.front_y || !b.check_collision.back_y) {
                    // trace('Y: Failed - (A>B) | max: ${this.max_overlap} | ${this.overlap}');                    
                    // FlxG.watch.addQuick("Y (A>B): Failed", true);
                    // FlxG.watch.addQuick("Y (A>B): Worked", false);                                                          
                    this.overlap = 0;
                } else {
                    // FlxG.watch.addQuick("Y (A>B): Failed", false);
                    // FlxG.watch.addQuick("Y (A>B): Worked", true);  

                    a.touching.none = false;
                    a.touching.back_y = true;
                    a.current_overlap = CollideSide.back_y;  

                    b.touching.none = false;
                    b.touching.front_y = true;      
                    b.current_overlap = CollideSide.front_y; 
                }

                // trace('0 - (A>B) | max: ${this.max_overlap} | ${this.overlap}');                     
            } else if (a.delta_y < b.delta_y) {
                // this.overlap = (b.front_y - a.y) - b.width_y;                
                this.overlap = FlxMath.roundDecimal((b.front_y - b.width_y) - a.y, this.decimal);                
                
                if ((-this.overlap > this.max_overlap) || a.check_collision.back_y == false || b.check_collision.front_y == false) {
                    // trace('Y: Failed - (A<B) | max: ${this.max_overlap} | ${this.overlap}');                      
                    // FlxG.watch.addQuick("Y (A<B): Failed", true);
                    // FlxG.watch.addQuick("Y (A<B): Worked", false);                                                          
                    this.overlap = 0;
                } else {
                    // FlxG.watch.addQuick("Y (A<B): Failed", false);
                    // FlxG.watch.addQuick("Y (A<B): Worked", true);  
                                                     
                    a.touching.none = false;
                    a.touching.front_y = true;
                    a.current_overlap = CollideSide.front_y; 

                    b.touching.none = false;
                    b.touching.back_y = true;
                    b.current_overlap = CollideSide.back_y;
                    
                    // trace('Y: Worked - (A<B) | max: ${this.max_overlap} | ${this.overlap}');                                 
                }

                // trace('End - (A<B) | max: ${this.max_overlap} | ${this.overlap}');
            }
        }

        if (this.overlap != 0) {           
            a.overlap_y = this.overlap;
            b.overlap_y = this.overlap;

            if (overlap) {
                return true;
            }

            this.a_overlap_velocity = a.velocity.y;
            this.b_overlap_velocity = b.velocity.y;

            if (!a.immovable && !b.immovable) {
                this.overlap *= 0.5;

                a.y = a.y - this.overlap;
                b.y += this.overlap;

                this.new_velocity_a = (this.b_overlap_velocity * this.b_overlap_velocity * b.weight) / a.weight * ((this.b_overlap_velocity > 0) ? 1 : -1);
                this.new_velocity_b = (this.a_overlap_velocity * this.a_overlap_velocity * a.weight) / b.weight * ((this.a_overlap_velocity > 0) ? 1 : -1);
                this.average = (this.new_velocity_a + new_velocity_b) * 0.5;
                
                this.new_velocity_a -= this.average;
                this.new_velocity_b -= this.average;

                a.velocity.y = FlxMath.roundDecimal(this.average + this.new_velocity_a * a.bounce.y, this.decimal);
                b.velocity.y = FlxMath.roundDecimal(this.average + this.new_velocity_b * b.bounce.y, this.decimal);                
            } else if (!a.immovable) {
                a.y = a.y - this.overlap;
                a.velocity.y = FlxMath.roundDecimal(this.b_overlap_velocity - this.a_overlap_velocity * a.bounce.y, this.decimal);
            } else if (!b.immovable) {
                b.y += this.overlap;
                b.velocity.y = FlxMath.roundDecimal(this.a_overlap_velocity - this.b_overlap_velocity * b.bounce.y, this.decimal);
            } 

            return true;
        }

        return false; 
    }

    public function SeperateZ(a:Body, b:Body, overlap:Bool):Bool {
        if(a.immovable && b.immovable) return false;

        this.overlap = 0;

        if (this.intersects(a, b)) {
            // this.max_overlap = Math.abs(a.delta_z) + Math.abs(b.delta_z) + this.overlap_bias;
            this.max_overlap = FlxMath.roundDecimal(a.abs_delta_z + b.abs_delta_z + this.overlap_bias, this.decimal);
            this.min_overlap = -this.max_overlap;

            if (a.delta_z == 0 && b.delta_z == 0) {
                a.implanted = true;
                b.implanted = true;                
            } else if (a.delta_z > b.delta_z) {
                // this.overlap = (a.top - b.z) - a.width_y;
                this.overlap = FlxMath.roundDecimal((a.top - a.height) - (b.z), this.decimal);

                           
                if ((this.overlap > this.max_overlap) || a.check_collision.top == false || b.check_collision.bottom == false) {
                    // trace('Z: Failed - (A>B) | max: ${this.max_overlap} | ${this.overlap}');                 
                    // FlxG.watch.addQuick("Z (A>B): Failed", true);
                    // FlxG.watch.addQuick("Z (A>B): Worked", false);                                                          
                    this.overlap = 0;
                } else {
                    // FlxG.watch.addQuick("Z (A>B): Failed", false);
                    // FlxG.watch.addQuick("Z (A>B): Worked", true);  

                    // trace('Z: Worked - (A>B) | max: ${this.max_overlap} | ${this.overlap}');

                    a.touching.none = false;
                    a.touching.top = true;
                    a.current_overlap = CollideSide.top;  

                    b.touching.none = false;
                    b.touching.bottom = true;      
                    b.current_overlap = CollideSide.bottom; 
                }

                // trace('0 - (A>B) | max: ${this.max_overlap} | ${this.overlap}');                     
            } else if (a.delta_z < b.delta_z) {
                var collide_z = (a.z) - (b.top - b.height);
                
                this.overlap = FlxMath.roundDecimal(collide_z, this.decimal);
                
                if (-this.overlap > this.max_overlap  || a.check_collision.bottom == false || b.check_collision.top == false) {
                    // trace('Z: Failed - (A<B) | max: ${this.max_overlap} | ${this.overlap}');
                    // FlxG.watch.addQuick("Z (A<B): Failed", true);
                    // FlxG.watch.addQuick("Z (A<B): Worked", false);                                                          
                    this.overlap = 0;
                } else {
                    // FlxG.watch.addQuick("Z (A<B): Failed", false);
                    // FlxG.watch.addQuick("Z (A<B): Worked", true);  

                    // trace('Z: Worked - (A<B) | max: ${this.max_overlap} | ${this.overlap}');                                     

                    a.touching.none = false;
                    a.touching.bottom = true;
                    a.current_overlap = CollideSide.bottom; 

                    b.touching.none = false;
                    b.touching.top = true;
                    b.current_overlap = CollideSide.top;            
                }

                // trace('End - (A<B) | max: ${this.max_overlap} | ${this.overlap}');
            }
        }

        if (this.overlap != 0) {           
            a.overlap_z = this.overlap;
            b.overlap_z = this.overlap;

            if (overlap) {
                return true;
            }

            this.a_overlap_velocity = a.velocity.z;
            this.b_overlap_velocity = b.velocity.z;

            if (!a.immovable && !b.immovable) {
                this.overlap *= 0.5;

                a.z = a.z - this.overlap;
                b.z += this.overlap;

                this.new_velocity_a = (this.b_overlap_velocity * this.b_overlap_velocity * b.weight) / a.weight * ((this.b_overlap_velocity > 0) ? 1 : -1);
                this.new_velocity_b = (this.a_overlap_velocity * this.a_overlap_velocity * a.weight) / b.weight * ((this.a_overlap_velocity > 0) ? 1 : -1);
                this.average = (this.new_velocity_a + new_velocity_b) * 0.5;
                
                this.new_velocity_a -= this.average;
                this.new_velocity_b -= this.average;

                a.velocity.z = FlxMath.roundDecimal(this.average + this.new_velocity_a * a.bounce.z, this.decimal);
                b.velocity.z = FlxMath.roundDecimal(this.average + this.new_velocity_b * b.bounce.z, this.decimal);                
            } else if (!a.immovable) {
                a.z = a.z - this.overlap;
                a.velocity.z = FlxMath.roundDecimal(this.b_overlap_velocity - this.a_overlap_velocity * a.bounce.z, this.decimal);

                if (b.moves) {
                    a.x += b.x - b.previous.x;
                    a.y += b.y - b.previous.y;
                }
            } else if (!b.immovable) {
                b.z += this.overlap;
                b.velocity.z = FlxMath.roundDecimal(this.a_overlap_velocity - this.b_overlap_velocity * b.bounce.z, this.decimal);

                if (a.moves) {
                    b.x += a.x - a.previous.x;
                    b.y += a.y - a.previous.y;
                }                
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
package system.world;

import haxe.ds.Vector;
import hxmath.math.Vector3;
import system.entities.IsoSprite; 
import flixel.FlxG;

class Depth {
    public var sort_depth:Int = 0;    
    public var behind_index:Int = 0;
    public var padding:Float = 15.5;
    public var objects_length:Int = 0;

    public function new() {
        
    }

    public function update_bounding_cube(sprite:IsoSprite) {
        sprite.iso_bounds.PreUpdate();        
        sprite.x = (FlxG.width / 2) + (sprite.iso_x - sprite.iso_y) * sprite.iso_bounds.width_x;
        sprite.y = (FlxG.height / 2) + (sprite.iso_x + sprite.iso_y - (sprite.iso_z * 2)) * (sprite.iso_bounds.half_width_y);
        sprite.z = (sprite.iso_z * 2) * (sprite.iso_bounds.half_height);           
        sprite.iso_bounds.PostUpdate();
    }

    public function transform_to_iso(x:Float, y:Float, z:Float, width_x:Float, half_width_y:Float, half_height:Float):Vector3 {

        var new_x = (FlxG.width / 2) + (x - y) * width_x;
        var new_y = (FlxG.height / 2) + (x + y - (z * 2)) * (half_width_y);
        var new_z = (z * 2) * (half_height);           

        var point = new Vector3(new_x, new_y, new_z);
        return point;
    }    

    public function find_overlaps(a_object:Vector<Float>, b_object:Vector<Float>):Bool {
        //var bounds = a_object.iso_bounds;
        
        if (b_object[0] + padding < a_object[0] - padding &&
                b_object[1] + padding < a_object[1] - padding &&
                    b_object[2] + padding < a_object[2] - padding) {
                    
                    return true;
        }      
        /**
        if (b_object.iso_bounds._x + padding < bounds.front_x - padding &&
                b_object.iso_bounds._y + padding < bounds.front_y - padding &&
                    b_object.iso_bounds._z + padding < bounds.top - padding) {
                        
                        return true;
        }          
        **/                  
        return false;
    }

    public function visit_node(node:IsoSprite) {
        if (node.iso_visited == 0) {
            node.iso_visited = 1;

            var sprites_behind_length = node.iso_sprites_behind.length;
            for (i in 0...sprites_behind_length) {
                if (node.iso_sprites_behind[i] == null) {
                    break;
                } else {
                    visit_node(node.iso_sprites_behind[i]);
                    node.iso_sprites_behind[i] = null;
                }
            }

            node.iso_depth = sort_depth++;
            

            
        }
    }
}
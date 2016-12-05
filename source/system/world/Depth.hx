package system.world;

import state.MenuState;
import haxe.ds.Vector;
import hxmath.math.Vector3;
import system.entities.IsoSprite; 
import flixel.FlxG;


class Depth {
    public var sort_depth:Int = 0;    
    public var behind_index:Int = 0;
    public var padding:Float = 0.08;
    public var objects_length:Int = 0;

    public function new() {
        
    }

    public function update_bounding_cube(sprite:IsoSprite) {
        sprite.x = ((sprite.iso_x - sprite.iso_y) * sprite.iso_bounds.width_x);
        sprite.y = ((sprite.iso_x + sprite.iso_y - (sprite.iso_z * 2)) * (sprite.iso_bounds.half_width_y));
        sprite.z = (sprite.iso_z * 2) * (sprite.iso_bounds.half_height);
    }

    public function transform_to_iso(x:Float, y:Float, z:Float, width_x:Float, half_width_y:Float, half_height:Float):Vector3 {

        var new_x = (x - y) * width_x;
        var new_y = (x + y - (z * 2)) * (half_width_y);
        var new_z = (z * 2) * (half_height);           

        var point = new Vector3(new_x, new_y, new_z);
        transform_to_2d(point.x, point.y, point.z);
        return point;
    }

    public function transform_to_2d(x:Float, y:Float, z:Float, width_x:Float = 32, half_width_y:Float = 16, half_height:Float = 16) {
        var center_x = x - (FlxG.width / 2);        
        var center_y = y - (FlxG.height / 2);
        var center_z = ((z / 2) / half_height);

        var out_z = (center_z * 2);   

        var out_y = -((center_x / width_x) - (center_y / half_width_y) + out_z);
        
        var new_x = (center_x / width_x) + (center_y / width_x);     
        var new_y = new_x - (center_y / half_width_y);

        var new_x = (center_x / width_x + center_y / width_x) / 2;
         
        
        // trace('${new_x} | ${out_y} | ${center_z}');    
    }

    // static public function IsoTo2D(map:FlxPoint):FlxPoint{
    //     //var StartX:Float = (FlxG.width / 2) - 32;
    //     //var StartY:Float = 100;
    //     var newX = map.x;
    //     var newY = map.y;

    //     var screen:FlxPoint = new FlxPoint(0, 0);

        
    //     screen.x = (newX / 32 + newY / 16) / 2;
    //     screen.y = (newY / 16 - (newX / 32)) / 2;        
                                         
                                        
    //     return(screen);
    // }

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
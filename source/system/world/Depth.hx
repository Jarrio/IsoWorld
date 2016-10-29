package system.world;

import haxe.ds.Vector;
import system.entities.IsoSprite; 

class Depth {
    public var sort_depth:Int = 0;    
    public var behind_index:Int = 0;
    public var padding:Float = 15.5;
    public var objects_length:Int = 0;

    public function new() {
        
    }

    public function update_bounding_cube(sprite:IsoSprite) {
        sprite.iso_bounds.PreUpdate();
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

    public function sort_loop(objects:Array<IsoSprite>):Void {
        for (i in 0...objects.length) {
            visit_node(objects[i]);
        }
    }

    public function visit_node(node:IsoSprite) {
        if (node.iso_visited == false) {
            node.iso_visited = true;

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
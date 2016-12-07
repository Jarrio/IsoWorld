package state;

import flixel.math.FlxVector;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;
import system.world.Chunk;
import system.world.Generate;
import flixel.math.FlxRect;
import hxmath.math.Vector2;
import flixel.math.FlxMath;
import system.world.Depth;


// class ChunkState extends FlxState {
    
//     public var chunks:Map<Int, FlxRect>; 
//     public var generate:Generate;
//     public var depth:Depth;

//     public var starting_x:Int = 0;
//     public var starting_y:Int = 0;

//     override public function create():Void {
//         super.create();
//         depth = new Depth();
//         generate = new Generate();


//         generate.Terrain();
//         generate.chunk();




//         chunks = new Map<Int, FlxRect>();
        
//         var num_chunks = generate.chunks_array.length;
        
//         var max_x = 0;
//         var max_y = 0;

//         for (i in this.generate.blocks.keys()) {
//             var x = i[0];
//             var y = i[1];
            
//             if (x > max_x) max_x = x;
//             if (y > max_y) max_y = y;
//         }

//         FlxG.watch.addQuick("max_x", max_x);
//         FlxG.watch.addQuick("max_y", max_y);
        
//         for (i in this.generate.chunks_array) {
//             trace(this.generate.chunks_array.length);
//             var sprite = new FlxSprite(i.iso_x * 32, i.iso_y * 32);
//             sprite.makeGraphic(32, 32, FlxColor.WHITE);
//             add(sprite); 
//         }




        

//     }

//     override public function update(elapsed:Float):Void {
//         super.update(elapsed);
        

//     }
// }
package system.world;

import libnoise.QualityMode;
import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxRandom;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import haxe.ds.Vector;
import system.entities.IsoSprite;
import system.entities.Block;
import system.world.Chunk;


class Generate {

    public var members:Array<IsoSprite> = new Array<IsoSprite>();
    // public var blocks:Array<Array<Array<IsoSprite>>>;

    public var blocks_total:Int = 0;
    public var blocks:Map<Array<Int>, IsoSprite> = new Map<Array<Int>, IsoSprite>();
    public var terrain:Noise;
    public var water:Noise;

    public var max_x = 12;
    public var max_y = 12;
    public var max_z = 4;

    

    public function new() {
        terrain = new Noise();
        // terrain.seed = 3;
        // terrain.seed = FlxG.random.int(0, 33000);
        terrain.seed = 3;
        terrain.frequency = 0.4;
        terrain.lacunarity = 0.96;
        terrain.octaves = 10;
        terrain.persistance = 0.9;
        terrain.quality = QualityMode.HIGH;

        terrain.generate();

        water = new Noise();
        // water.seed = 1;
        // water.seed = FlxG.random.int(0, 33000);
        water.seed = 3;
        water.frequency = 0.1;
        water.lacunarity = 0.8;
        water.octaves = 3;
        water.persistance = 0.2;
        water.quality = QualityMode.LOW;
        
        water.generate();

        trace("Creating Chunks");
        create_chunks();
        if (this.available_chunks.length > 0) trace("Finished making " + this.available_chunks.length + " chunks");
        
        trace("Assign Blocks");
        fill_chunks();
        trace("Added a total of: " + total_blocks + " blocks");

    }

    /*****
     * Draw Loop: 4.7ms
     * Update Loop: 120ms 
     * FPS: 7.3
     * Draw: 1.6k
     * Draw tiles: 1107
     *
     * 12 x 12 x 4
     ******/

    public var max_chunks:Int = 6;
    public var chunk_dimensions:Int = 3;
      
    public var available_chunks:Array<Chunk> = new Array<Chunk>();

    public function create_chunks() {
        for (x in 0...max_chunks) {
            for (y in 0...max_chunks) {
                var new_chunk = new Chunk(x, y);
                available_chunks.push(new_chunk);
            }
        }
    }
    
    public var total_blocks:Int = 0;
    public function fill_chunks() {
        for (i in 0...this.available_chunks.length) {
            var chunk = this.available_chunks[i];
            for (x in 0...this.chunk_dimensions) {
                var new_x = x + (chunk.chunk_x * this.chunk_dimensions);

                for (y in 0...this.chunk_dimensions) {
                    var new_y = y + (chunk.chunk_y * this.chunk_dimensions);
                    for (z in 0...this.chunk_dimensions) {
                        
                        var block = this.Terrain(new_x, new_y, z);
                        chunk.add_block(block);
                        // this.block(x, y, z, AssetPaths.new_light_grass__png, false);
                        this.total_blocks++;
                    }
                }
            }
        }
    }

    public function Terrain(x:Int, y:Int, z:Int) {
        var nx = x/max_x - 0.5;
        var ny = y/max_y - 0.5;
        var nz = z/max_z - 0.5;

        var e = (0.62 * terrain.value((1*nx), (1*ny), (1*nz)) +
                    0.50 * terrain.value((2*nx), (2*ny), (2*nz)) +
                    0.25 * terrain.value((4*nx), (4*ny), (4*nz)) +
                    0.13 * terrain.value((8*nx), (8*ny), (8*nz)) +
                    0.06 * terrain.value((16*nx), (16*ny), (16*nz)) +
                    0.03 * terrain.value((32*nx), (32*ny), (32*nz)));
        
        e /= (0.62 + 0.50 + 0.25 + 0.13 + 0.06 + 0.03);

        e = Math.pow(e, 1.14);

        var m = (0.00 * water.value((1*nx), (1*ny), (1*nz)) +
                    0.34 * water.value((2*nx), (2*ny), (2*nz)) +
                    0.80 * water.value((4*nx), (4*ny), (4*nz)) +
                    0.82 * water.value((8*nx), (8*ny), (8*nz)) +
                    0.53 * water.value((16*nx), (16*ny), (16*nz)) +
                    0.89 * water.value((32*nx), (32*ny), (32*nz)));

        m /= (0.00+0.34+0.80+0.82+0.53+0.89);

        var noise_return = this.biome(e, m);

        var new_block = null;
        if (noise_return == Blocks.Water) new_block = this.block(x, y, z, AssetPaths.new_water_cube__png);
        if (noise_return == Blocks.Grass) new_block = this.block(x, y, z, AssetPaths.new_light_grass__png);
        if (noise_return == Blocks.Sand) new_block = this.block(x, y, z, AssetPaths.new_sand_cube__png);                        
        if (noise_return == Blocks.Dark_Grass) new_block = this.block(x, y, z, AssetPaths.new_dark_grass_cube__png);                       
        if (noise_return == Blocks.Mud) new_block = this.block(x, y, z, AssetPaths.new_mud_cube__png);
        if (noise_return == Blocks.Dead) new_block = this.block(x, y, z, AssetPaths.new_dead_cube__png);                        
        if (noise_return == Blocks.Snow) new_block = this.block(x, y, z, AssetPaths.snow_slab__png);                        
        if (noise_return == Blocks.Air) new_block = this.block(x, y, z, AssetPaths.air_cube__png, true);
        
        return new_block;
                                          
    }

    public function old_Terrain() {
        for (x in 0...max_x) {
            for (y in 0...max_y) {
                for (z in 0...max_z) {
                    var nx = x/max_x - 0.5;
                    var ny = y/max_y - 0.5;
                    var nz = z/max_z - 0.5;

                    var e = (0.62 * terrain.value((1*nx), (1*ny), (1*nz)) +
                             0.50 * terrain.value((2*nx), (2*ny), (2*nz)) +
                             0.25 * terrain.value((4*nx), (4*ny), (4*nz)) +
                             0.13 * terrain.value((8*nx), (8*ny), (8*nz)) +
                             0.06 * terrain.value((16*nx), (16*ny), (16*nz)) +
                             0.03 * terrain.value((32*nx), (32*ny), (32*nz)));
                    
                    e /= (0.62 + 0.50 + 0.25 + 0.13 + 0.06 + 0.03);

                    e = Math.pow(e, 1.14);

                    var m = (0.00 * water.value((1*nx), (1*ny), (1*nz)) +
                             0.34 * water.value((2*nx), (2*ny), (2*nz)) +
                             0.80 * water.value((4*nx), (4*ny), (4*nz)) +
                             0.82 * water.value((8*nx), (8*ny), (8*nz)) +
                             0.53 * water.value((16*nx), (16*ny), (16*nz)) +
                             0.89 * water.value((32*nx), (32*ny), (32*nz)));

                    m /= (0.00+0.34+0.80+0.82+0.53+0.89);

                    var noise_return = this.biome(e, m);
                    if (noise_return == Blocks.Water) this.block(x, y, z, AssetPaths.new_water_cube__png);
                    if (noise_return == Blocks.Grass) this.block(x, y, z, AssetPaths.new_light_grass__png);
                    if (noise_return == Blocks.Sand) this.block(x, y, z, AssetPaths.new_sand_cube__png);                        
                    if (noise_return == Blocks.Dark_Grass) this.block(x, y, z, AssetPaths.new_dark_grass_cube__png);                       
                    if (noise_return == Blocks.Mud) this.block(x, y, z, AssetPaths.new_mud_cube__png);
                    if (noise_return == Blocks.Dead) this.block(x, y, z, AssetPaths.new_dead_cube__png);                        
                    if (noise_return == Blocks.Air) this.block(x, y, z, AssetPaths.air_cube__png, true);
                                            
                    // if (noise_return == Blocks.Snow) this.block(x, y, z, AssetPaths.snow_slab__png);              
                }
            }
        }
    }  


    
    public function chunk() {

        var max_x:Null<Int> = null;
        var max_y:Null<Int> = null;

        for (i in this.blocks.keys()) {
            var x = i[0];
            var y = i[1];
            
            if (x > max_x) max_x = x;
            if (y > max_y) max_y = y;
        }

        
        // var total_chunks = Std.int(this.blocks_total / (this.chunk_size * this.chunk_size * this.chunk_size));
        
        // for (x in 0...chunk_rows) {
        //     var new_chunk = new Chunk(x);
        //     for (y in 0...chunk_rows) {
        //         for (get_block in 0...(this.chunk_size * this.chunk_size * this.chunk_size)) {
        //             var block = this.members.pop();
        //             if (block != null) {                
        //                 new_chunk.add_block(block);                    
        //             }
        //         }
        //         new_chunk.iso_x = x;
        //         new_chunk.iso_y = y;
        //     }
        //     new_chunk.categorise();
        //     chunks_array.push(new_chunk);
        // }


        // for (cur_chunk in 0...chunks) {
            
        //     var new_chunk = new Chunk(cur_chunk);            
        //     for (i in 0...(chunk_size*chunk_size*chunk_size)) {
        //         var block = this.members.pop();
        //         block.chunk_id = cur_chunk;
        //         new_chunk.add_block(block);
        //     }

        //     new_chunk.categorise();
        //     chunks_array.push(new_chunk);
        // }
    }

    public function biome(e:Float, m:Float):Blocks {
        if (e < 0.24) return Blocks.Air;
        if (e < 0.25) return Blocks.Water;
        if (e < 0.28) return Blocks.Sand;
        

        if (e > 0.4) {
            if (m < 0.16) return Blocks.Dark_Grass;
            if (m < 0.30) return Blocks.Mud;
            if (m < 0.50) return Blocks.Dead;            
            return Blocks.Air;
        }

        if (e > 0.3) {
            if (m < 0.10) return Blocks.Mud;
            if (m < 0.33) return Blocks.Dark_Grass;
            if (m < 0.66) return Blocks.Grass;
            return Blocks.Snow;
        }

        return Blocks.Air;
    }

    

    public function block(x:Int, y:Int, z:Int, graphic:String, air:Bool = false) {
        var block = new Block(x, y, z, graphic, air);
        this.members.push(block);
        // blocks.push([x][y][z]block);

        var obj = [x, y, z];

        blocks.set(obj, block);

        blocks_total++;
        return block;
    }
    /**
    public function LoadBlocks() {
        for (y in 2...7) {
            for (x in 7...20) {
                var random_height = new FlxRandom().int(1, 2);
                for (z in 0...random_height) {
                    var new_chunk = new Block(x, y, z);
                    members.push(new_chunk);
                }
            }
        }
    }**/

}
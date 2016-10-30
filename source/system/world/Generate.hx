package system.world;

import libnoise.QualityMode;
import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxRandom;

import system.entities.IsoSprite;
import system.entities.Block;



class Generate {

    public var members:Array<IsoSprite> = new Array<IsoSprite>();
    public var terrain:Noise;
    public var water:Noise;

    public function new() {
        terrain = new Noise();
        terrain.seed = 3;
        terrain.frequency = 0.4;
        terrain.lacunarity = 0.96;
        terrain.octaves = 6;
        terrain.persistance = 0.4;
        terrain.quality = QualityMode.HIGH;

        water = new Noise();
        water.seed = 1;
        water.frequency = 0.1;
        water.lacunarity = 0.8;
        water.octaves = 3;
        water.persistance = 0.2;
        water.quality = QualityMode.HIGH;
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
    public function Terrain() {
        var max_x = 12;
        var max_y = 12;
        var max_z = 4;
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
                    if (noise_return == Blocks.Water) this.block(x, y, z, AssetPaths.water_cube__png);
                    if (noise_return == Blocks.Grass) this.block(x, y, z, AssetPaths.green_cube_v2__png);
                    if (noise_return == Blocks.Sand) this.block(x, y, z, AssetPaths.sand_cube__png);                        
                    if (noise_return == Blocks.Dark_Grass) this.block(x, y, z, AssetPaths.darker_grass_cube__png);                       
                    if (noise_return == Blocks.Mud) this.block(x, y, z, AssetPaths.mud_cube__png);
                    if (noise_return == Blocks.Dead) this.block(x, y, z, AssetPaths.dead_cube__png);                        
                    if (noise_return == Blocks.Snow) this.block(x, y, z, AssetPaths.grey_snow_cube__png);              
                }
            }
        }
    }

    public function biome(e:Float, m:Float):Blocks {
        if (e < 0.25) return Blocks.Water;
        if (e < 0.28) return Blocks.Sand;

        if (e > 0.4) {
            if (m < 0.16) return Blocks.Dark_Grass;
            if (m < 0.30) return Blocks.Mud;
            if (m < 0.50) return Blocks.Dead;            
            return Blocks.Snow;
        }

        if (e > 0.3) {
            if (m < 0.10) return Blocks.Mud;
            if (m < 0.33) return Blocks.Dark_Grass;
            if (m < 0.66) return Blocks.Grass;
            return Blocks.Snow;
        }

        return Blocks.Air;
    }

    public function block(x:Int, y:Int, z:Int, graphic) {
        var block = new Block(x, y, z, graphic);
        members.push(block);
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
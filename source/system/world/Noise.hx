package system.world;

import libnoise.generator.Perlin;
import libnoise.QualityMode;

class Noise {
    public var frequency:Float = 0.68;
    public var lacunarity:Float = 0.4;
    public var persistance:Float = 0.2;
    public var octaves:Int = 3;
    public var seed:Int = 21;
    public var quality:QualityMode = QualityMode.HIGH;

    public var noise:Perlin;

    public function new() {}
    
    public function generate() {
        noise = new Perlin(frequency, lacunarity, persistance, octaves, seed, quality);
    }

    public function value(nx:Float, ny:Float, nz:Float):Float {
        return noise.getValue(nx, ny, nz) / 2.0 + 0.5;        
    }


}
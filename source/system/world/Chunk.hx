package system.world;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import system.entities.IsoSprite;
using flixel.util.FlxArrayUtil;

class Chunk extends FlxTypedSpriteGroup<IsoSprite> {

    public var processed:Bool = false;
    
    public var chunk_x:Int = 0;
    public var chunk_y:Int = 0;

    public function new(x:Int, y:Int) {
        super();
        this.chunk_x = x;
        this.chunk_y = y;
    }

    public function add_block(block:IsoSprite) {
        if (!block.air)             
            this.add(block);
    }
}   
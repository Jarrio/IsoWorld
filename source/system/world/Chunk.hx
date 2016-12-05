package system.world;

import system.entities.IsoSprite;

class Chunk extends IsoSprite {

    public var id:Int = 0;
    public var blocks:Array<IsoSprite> = new Array<IsoSprite>();
    
    public var min_x:Int = 9999999;
    public var min_y:Int = 9999999;
    
    public var max_x:Int = -9999999;
    public var max_y:Int = -9999999;

    public function new(id:Int) {
        super(null, null, null, null, null);
        this.chunk_id = id;
    }

    public function add_block(block:IsoSprite) {    
        this.blocks.push(block);
    }

    public function categorise() {
        for (i in 0...blocks.length) {
            var block = this.blocks[i];
            if (block.iso_x < this.min_x) this.min_x = Math.ceil(block.iso_x);
            if (block.iso_y < this.min_y) this.min_y = Math.ceil(block.iso_y);

            if (block.iso_x > this.max_x) this.max_x = Math.ceil(block.iso_x);
            if (block.iso_y > this.max_y) this.max_y = Math.ceil(block.iso_y);
        }
    }
}
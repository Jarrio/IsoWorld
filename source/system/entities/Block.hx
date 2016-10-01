package system.entities;

import system.constants.BlockTypes;
import system.entities.interfaces.BlockPattern;
import flixel.FlxSprite;

class Block implements BlockPattern extends FlxSprite {

    public var id:Int;
    public var type:BlockTypes;
    
    public function new(cellx:Int, celly:Int) {
        super();
        loadGraphic(AssetPaths.base_cube__png);
    } 
}
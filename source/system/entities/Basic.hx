package system.entities;
import flixel.FlxSprite;
import system.constants.BasicTypes;
using flixel.util.FlxSpriteUtil;
class Basic extends FlxSprite {
    public var z:Int;
    public var id:Int;
    public var type:BasicTypes;
    public var depth:Float;
    
    public function new(x:Float, y:Float, graphic:String) {
        super(x, y, graphic);
    }
}
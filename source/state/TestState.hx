package state;


import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class TestState extends FlxState {

    public var test:FlxSprite;
    public var sprite_1:FlxSprite;
    public var sprite_2:FlxSprite;
    override public function create():Void {
        super.create();
        
        sprite_1 = new FlxSprite(0, 0);
        sprite_1.makeGraphic(20, 20, FlxColor.BLUE);
        sprite_2 = new FlxSprite(25, 25);
        sprite_2.makeGraphic(20, 20, FlxColor.RED);

        

        add(sprite_1);
        add(sprite_2);

    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        
        // FlxG.collide(sprite_1, sprite_2, test);
    }
}
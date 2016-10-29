package state;


import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;

class TestState extends FlxState {

    public var array_1:Array<String> = new Array<String>();
    public var array_2:Array<String> = new Array<String>();
    public var array_3:Array<String> = new Array<String>();

    public var test:FlxSprite;
    override public function create():Void {
        super.create();
        
        test = new FlxSprite();
        test.loadGraphic(AssetPaths.green_cube__png, true, 16, 16);

        test.animation.add("first", [1, 2, 3, 4, 5], 10, true);

        add(test);
        test.animation.play("first");


    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        var last_frame = test.animation.curAnim.frames.length;
        if (test.animation.frameIndex == last_frame) {
            trace('Finished: true');
        }
        
		if(FlxG.keys.pressed.H) {
		}
    }
}
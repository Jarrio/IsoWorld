package state;


import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class TestState extends FlxState {

    public var test:FlxSprite;
    override public function create():Void {
        super.create();
        
        test = new state.Test(100, 100);
        test.loadGraphic(AssetPaths.Mouths__png, true, 24, 12);
        // test.animation.add("happy", [0], 1);
        // test.animation.add("sad", [1], 1);
        // test.animation.add("shock", [2], 1);

        add(test);
        // test.animation.play("happy");


    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        
		if(FlxG.keys.pressed.H) {
            this.bgColor = FlxColor.WHITE;
		} 

        if(FlxG.keys.pressed.J) {
            this.bgColor = FlxColor.BLACK;
		}

        if (FlxG.keys.pressed.MINUS) {
            this.test.scale.x -= 0.1;
            this.test.scale.y -= 0.1;

        } 

        if (FlxG.keys.pressed.PLUS) {
            this.test.scale.x += 0.1;
            this.test.scale.y += 0.1;
        }         
    }
}
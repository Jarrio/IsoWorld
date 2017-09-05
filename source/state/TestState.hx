package state;


import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;

class TestState extends FlxState {
    public var object:FlxSprite;
    public var tween:FlxTween;


    override public function create():Void {
        super.create();
        var start = new FlxText(50, 50, 0, "Hello");
        start.color = FlxColor.WHITE;

        var end = new FlxText(50, 200, 0, "End");
        end.color = FlxColor.WHITE;

        add(start);
        add(end);
        
        object = new FlxSprite(50, 100);
        object.makeGraphic(25, 25, FlxColor.WHITE);

        add(object);        

        tween = FlxTween.linearMotion(this.object, start.x, start.y + 35, end.x, end.y + 35, 10, true, {type: FlxTween.LOOPING});
        tween.start();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (FlxG.keys.anyPressed(["SPACE"])) {
            this.tween.percent = 1;
        }
        
    }
}
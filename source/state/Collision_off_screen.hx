package state;


import flixel.FlxObject;
import flixel.FlxCamera;
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
        sprite_2 = new FlxSprite(-300, 0);
        sprite_2.makeGraphic(20, 20, FlxColor.RED);

        sprite_2.immovable = true;
        sprite_2.allowCollisions = FlxObject.ANY;
        sprite_1.allowCollisions = FlxObject.ANY;
        this.camera.follow(sprite_1, FlxCameraFollowStyle.LOCKON);

        add(sprite_1);
        add(sprite_2);

    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        // FlxG.collide(sprite_1, sprite_2, test);
        var up = FlxG.keys.pressed.UP;
        var down = FlxG.keys.pressed.DOWN;
        var left = FlxG.keys.pressed.LEFT;
        var right = FlxG.keys.pressed.RIGHT;

        if(FlxG.collide(sprite_1, sprite_2)) {
            trace("collided");
        } else {
            trace("false");
        }

        if (up) {
            this.sprite_1.y += 10; 
        } else if (down) {
            this.sprite_1.y -= 10;
        } else if (left) {
            this.sprite_1.x += 10;
        } else if (right) {
            this.sprite_1.x -= 10;
        }


    }
}
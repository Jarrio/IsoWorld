package state;


import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;

class TestState extends FlxState {
    public var group:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
    override public function create():Void {
        super.create();

        for (i in 0...10) {
            group.add(new FlxSprite(i * 10, 10));            
        }

        add(group);
        // var test = group.members.splice(0, 1); 
        group.remove(group.members[0], true);

        for (i in 0...group.members.length) {
            trace(group.members[i].x);
        }
        
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        
    }
}
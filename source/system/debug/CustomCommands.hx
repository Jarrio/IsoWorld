package system.debug;

import flixel.FlxG;
import system.entities.IsoSprite;
import state.MenuState;

class CustomCommands {
    private var state:MenuState;
    public function new(state:MenuState) {
        this.state = state;
    }

    public function sprite(sprite:IsoSprite) {
        var iso = FlxG.debugger.track(sprite, sprite.entity + " sprite");
        iso.reposition(0, iso.height + iso.height);

        var body_height = iso.y + iso.height;
        FlxG.debugger.track(sprite.iso_bounds, sprite.entity + " body").reposition(0, body_height);
    }

    // public function group(member:Int):IsoSprite {
    //     var sprite = new IsoSprite();
    //     if (this.state.group.members[member] != null) {
    //         // sprite = this.state.group.members[member];
    //     }

    //     // return sprite;
    // }    


}
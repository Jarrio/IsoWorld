package system.debug;

import system.entities.physics.Body;
import system.entities.physics.Cube;
import system.entities.IsoSprite;
import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.system.debug.watch.Tracker.TrackerProfile;
class TrackerProfiles {

    public var profiles:Array<TrackerProfile>;

    public function new() {
        profiles = new Array<TrackerProfile>();
        IsoSpriteProfile();        
        BodyProfile();
    }

    private function IsoSpriteProfile() {
        var profile = new TrackerProfile(IsoSprite, ["iso_depth", "x", "y", "z", "iso_position"]);
        profiles.push(profile);
    }

    private function BodyProfile() {
        var profile = new TrackerProfile(Body, ["speed", "delta_x", "delta_y", "delta_z", "position", "previous", "velocity", "current_overlap", "overlap_y", "overlap_z", "overlap_x", "facing"]);
        profiles.push(profile);
    }
}
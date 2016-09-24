package system.grid;

import flixel.FlxSprite;

class Tile extends FlxSprite {

    public function new() {
        super();
        this.loadGraphic(AssetPaths.base_iso_tile__png);
    }
}
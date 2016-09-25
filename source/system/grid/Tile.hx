package system.grid;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import system.helpers.Isometric;

class Tile extends FlxSprite {
    public var number = new FlxText();
    public function new(cellx:Int, celly:Int) {
        var _point = Isometric.TwoDToIso(new FlxPoint(cellx, celly));

        super(_point.x, _point.y);

        this.loadGraphic(AssetPaths.base_iso_tile__png);
        
        number.color = FlxColor.BLACK;
        number.text = '(${celly}, ${cellx})';
        number.x = this.x + (this.width / 2) - (number.fieldWidth / 2);
        number.y = this.y + (this.height / 2) - (number.height / 2);
    }
}
package system.entities;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import system.helpers.Isometric;

class Player extends Basic {

    public function new(_x:Int, _y:Int, _z:Int) {
        super();

        Entity = "Player";    
        
        loadGraphic(AssetPaths.green_cube__png);
        this.centerOffsets(true);
        this.centerOrigin();
        MinXRelative = -32;
        MaxXRelative = 32;
         
        MinYRelative = -32;
        MaxYRelative = 32;

        MinZRelative = -32;
        MaxZRelative = 32;
        set_iso_coords(_x, _y, _z);
        
        color = FlxColor.RED; 



     
        
        //trace('ox: ${cellx} oy: ${celly} ± nx: ${oldpoint.x} ny: ${oldpoint.y} ± gx: ${this.x} gy: ${this.y}');
    }

    public var Speed:Int = 1;
    public var Jump:Bool = false;
    public var Movekey:Bool = false;

    

    public var UpdateSort:Bool = false;

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.anyJustPressed(['W', 'Up'])) {
            IsoY -= 1;
            Movekey = true;
        } else if (FlxG.keys.anyJustPressed(['S', 'Down'])) {
            IsoY += 1;
            Movekey = true;
        } else if (FlxG.keys.anyJustPressed(['A', 'Left'])) {
            IsoX -= 1;
            Movekey = true;
        } else if (FlxG.keys.anyJustPressed(['D', 'Right'])) {
            IsoX += 1;
            Movekey = true;
        } else if (FlxG.keys.justPressed.M) {
            IsoZ += 1;
            Movekey = true;
        } else if (FlxG.keys.justPressed.N) {
            IsoZ -= 1;
            Movekey = true;
        }

        if (Movekey) {  
            Movekey = false;
            UpdateSort = true;
            set_iso_coords(null, null, null);
        }      
        

        if (FlxG.mouse.overlaps(this)) {
            if (FlxG.mouse.justPressed) {
                //FlxG.log.notice(return_debug_values('Player ${IsoDepth}'));
                FlxG.log.notice('Type: {${this.Entity}} | FrontX: ${this.FrontX} | FrontY: ${this.FrontY} | Top: ${this.Top}');
            }
        }

        FlxG.watch.addQuick("Player Depth", '${this.IsoDepth}');
        FlxG.watch.addQuick("Player Axis", 'x: ${x} | y: ${y} |  z: ${z}');
        FlxG.watch.addQuick("Player Coords", 'x: ${IsoX} | y: ${IsoY} | z:${IsoZ}');
        
        // FlxG.watch.addQuick("Player Min", 'x: ${MinX} | y: ${MinY} | z:${MinZ}'); 
        // FlxG.watch.addQuick("Player Max", 'x: ${MaxX} | y: ${MaxY} | z:${MaxZ}'); 
         
        
    }


}
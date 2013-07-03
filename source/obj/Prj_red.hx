package obj;

import openfl.Assets;
import org.flixel.*;
import org.flixel.util.*;
import tmx.*;

class Prj_red extends FlxSprite {

    override public function new(o:TmxObject):Void {

    	super(o.x +6, o.y +6);

        loadGraphic("assets/sprites/prj_red.png");

        width = 2;
        height = 2;
    }

    var t_timer:Int = 0;

    override public function update():Void {

        t_timer++;

        super.update();

        if ( FlxMath.getDistance( MjG.getPlayer().getMidpoint(), this.getMidpoint() ) < 12 || t_timer > 60) {
            
            if (t_timer < 60)   MjM.restartLevel();

            this.kill();
            this.destroy();
        }
    }
}
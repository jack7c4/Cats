package obj;

import openfl.Assets;
import org.flixel.*;
import tmx.*;

class ObjT1_hdoor extends ObjMain {

    override public function new(o:TmxObject):Void {

    	super(o.x, o.y -33, o);

        loadGraphic("assets/sprites/t1hdoor.png", true, false, 49, 32);
        addAnimation("open", [1]);
        addAnimation("close", [0]);
        play("close");

        height = 16;
        offset.y = 8;
        offset.x = 0;

        immovable = true;
    }

    override public function activate(state:Int = 0):Void {

    	play("open");
    	allowCollisions = 0;
    }
}
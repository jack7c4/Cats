package obj;

import openfl.Assets;
import org.flixel.*;
import tmx.*;

class ObjT1_vdoor_top extends Event {

    override public function new(o:TmxObject):Void {

    	super(o.x, o.y-72, o);

    	this.tag = 0;

        loadGraphic("assets/sprites/t1vdoor_top.png", true, false, 16, 64);
        addAnimation("open", [0]);
        play("open");

        height = 28;

        immovable = true;
    }
}
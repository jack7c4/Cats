package obj;

import openfl.Assets;
import org.flixel.*;
import tmx.*;

class ObjT1_kguide extends ObjMain {

    override public function new(?o:TmxObject):Void {

    	super(o.x +4, o.y -8, o);

        loadGraphic("assets/sprites/t1kguide.png", true, false, 28, 40);

        addAnimation("stand", [0], 6);

        play("stand");

        immovable = true;

        width = 10;
        height = 8;
        offset.y = 30;
        offset.x = 8;
    }
}
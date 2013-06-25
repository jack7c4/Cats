package obj;

import openfl.Assets;
import org.flixel.*;
import tmx.*;

class ObjT1_pillar extends ObjMain {

    override public function new(o:TmxObject):Void {

    	super(o.x, o.y -16, o);

        loadGraphic("assets/sprites/t1pillar.png", true, false, 16, 32);

        if (gid==MjO.T1_PILLAR_GREEN) addAnimation("main", [0]);
        else addAnimation("main", [2]);

        play("main");

        height = 4;
        offset.y = 20;

        immovable = true;
    }
}
package obj;

import openfl.Assets;
import org.flixel.*;
import tmx.*;

class ObjS1_kbot extends Actor {

    override public function new(o:TmxObject):Void {

        super(o.x +2, o.y -6, o);

        loadGraphic("assets/sprites/s1_kbot.png", true, false, 28, 32);

        addAnimation("stand", [0]);
        addAnimation("walk", [4,5,6,7], 6);
        addAnimation("aim", [8,9,10], 5, false);
        addAnimation("shoot", [11,9], 7, false);

        width = 10;
        height = 8;
        offset.y = 34;
        offset.x = 4;
    }
}
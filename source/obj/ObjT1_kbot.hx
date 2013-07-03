package obj;

import openfl.Assets;
import org.flixel.*;
import tmx.*;

class ObjT1_kbot extends Actor {

    override public function new(o:TmxObject):Void {

        super(o.x +2, o.y -8, o);

        loadGraphic("assets/sprites/t1kguide.png", true, false, 28, 40);

        addAnimation("stand", [1]);
        addAnimation("walk", [4,5,6,7], 6);

        width = 10;
        height = 8;
        offset.y = 34;
        offset.x = 4;
    }
}
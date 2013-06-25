package map;

import openfl.Assets;
import org.flixel.*;
import tmx.*;
import obj.*;

class MapStory extends MapEvent {

	override public function new(o:TmxObject):Void {

		//initialise(o);
        super(o.x, o.y, o);

        makeGraphic(4, 4, 0x88008888);

        allowCollisions = 0;

        if (name=="intro") MjG.addObject(new ObjT1_kguide(o));
        else if (name=="bot") MjG.addObject(new ObjT1_kbot(o));
	}
}
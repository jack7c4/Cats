package;

import openfl.Assets;
import org.flixel.*;
import org.flixel.util.*;
import tmx.*;

class Trigger extends Event {

	override public function new(o:TmxObject):Void {

        super(o.x, o.y-16, o);

        if (gid == MjE.PLAYER_EXIT) name = "exit";

        makeGraphic(16, 16, 0x88880000);
	}

	public function reset_event():Void {

		switch (method) {

			case "switch":
				MjG.switchTileBack(getMidpoint());
		}

		active = true;

		super.reset(x, y);
	}

	override public function activate(state:Int = 0):Void {

		if (!active) return;
		active = false;

		if (name=="exit") MjM.nextLevel();

		switch (method) {

			case "switch":
				MjG.switchTile(getMidpoint());
		}

		if (action=="script") MjM.activateEvents(tag);
		else MjG.activateEvents(tag);

		/*switch (properties["action"]) {

			case "open":
				for (o in MjG.getEvents(tag)) if (o.state!=1) o.activate();

			case "close":
				for (o in MjG.getEvents(tag)) if (o.state!=2) o.activate();

			case "script":
				//MjM.activateEvents(tag);
		}*/

		if (repeat==true) {

			var delay = new FlxTimer();
			delay.start(2.5, 1, function (a:FlxTimer) { reset_event; });
		}
	}
}
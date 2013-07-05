package;

import org.flixel.*;
import obj.*;
import tmx.*;

class MjE {

    static inline public var TILESET_LENGTH = 48;

    // Object definitions

    static inline public var PLAYER_START       :Int = 3;
    static inline public var PLAYER_EXIT        :Int = 2;
    static inline public var TRIGGER            :Int = 10;
    static inline public var TARGET             :Int = 18;
    static inline public var PATROL_POINT       :Int = 19;
    static inline public var STORY              :Int = 26;
    static inline public var T1_PILLAR_PURPLE   :Int = 33;
    static inline public var T1_PILLAR_GREEN    :Int = 34;
    static inline public var T1_VDOOR_PURPLE    :Int = 35;
    static inline public var T1_HDOOR_GREEN     :Int = 36;
    static inline public var T1_KGUIDE    		:Int = 41;
    static inline public var T1_KBOT    		:Int = 42;
    static inline public var PRJ_RED    		:Int = 201;

    static private var player:Player;

	static public function get_player():Player {

		return player;
	}

	static public function switchObject(o:TmxObject):Void {

		o.gid -= TILESET_LENGTH;

		var gameEvents:FlxGroup = PlayState.get_gameEvents();
		var gameObjects:FlxGroup = PlayState.get_gameObjects();

		switch (o.gid) {
			
			case PLAYER_START:
				player = new Player(o);
				gameObjects.add(player);

			case TRIGGER, PLAYER_EXIT:
				gameEvents.add(new Trigger(o));



			case TARGET, PATROL_POINT:
				gameEvents.add(new Target(o));




			case T1_PILLAR_GREEN, T1_PILLAR_PURPLE:
				gameObjects.add(new ObjT1_pillar(o));

			case T1_VDOOR_PURPLE:
				gameObjects.add(new ObjT1_vdoor_top(o));
				gameObjects.add(new ObjT1_vdoor_bottom(o));

			case T1_HDOOR_GREEN:
				gameObjects.add(new ObjT1_hdoor(o));

			case T1_KGUIDE:
				gameObjects.add(new ObjS1_kbot(o));

			case T1_KBOT:
				gameObjects.add(new ObjT1_kbot(o));


			case PRJ_RED:
				gameObjects.add(new Prj_red(o));
		}
	}

	static public function switchProperties(o:Dynamic, ps:Map<String, String>) {

		for (k in ps.keys()) {

			switch (k) {

				case "tag": 	o.tag = Std.parseInt(ps[k]);
				case "action": 	o.action = ps[k];
				case "method": 	o.method = ps[k];
				case "repeat": 	o.repeat = (ps[k]=="true") ? true : false;
				case "active": 	o.active = (ps[k]=="true") ? true : false;
			}
		}

	}

	static var ps:Bool = true;		// Parse Saftey, don't let script parse twice
	static var pv:Int;	 			// Parse Level: filter, object, componant, property, value
	static var pp:Int;				// Parse Pointer, counter for line
	static var pl:Int;				// Parse Last, index of last entry
	static var pa:Array<String>;	// Parse Array, of lines
	static var ta:Actor;			// Temp Actor

	static public function parseScript():Void {

		if (ps) return;
		ps = false;

	    pa = openfl.Assets.getText('assets/actors/script.txt').split("\n");
	    pl = pa.length -1;
	
		while (pp <= pl) {

			//trace('pp: $pp; pl: $pl;');

			if (pv==0) {					// Filter everything through parse_filterChar

				var tl:String = "";			// Temp Line
				var tc:String;				// Temp Char
				var c:Int = 0;				// Counter
				var l:Int = pa[pp].length;	// Last

				while (c < l) {

					tc = pa[pp].charAt(c);
					if (parse_filterChar(tc)) tl += tc.toLowerCase();
					c++;
				}

				if (pp == pl) {

					pv++;
					pp = 0;
				}
			}

			else if (pa[pp]=="") null;		// Empty line, ignore

			else if (pv==1) {				// Identify an object (actor, projectile, obstacle, decoration)

				//trace("pv is one");

				if (pa[pp+1].substr(0,3)=="---" && parse_objectAssert(pa[pp])) {

					//ta = new Actor();
				}
				
				else parse_error("Object definition not found: have you added hyphens under it?");
			}


			pp++;
		}

	}

	static function parse_objectAssert(s:String):Bool {

		if (s.substr(0,5) =="actor") 		return true;
		if (s.substr(0,10)=="projectile") 	return true;
		if (s.substr(0,8) =="obstacle") 	return true;
		if (s.substr(0,10)=="decoration") 	return true;
		return false;
	}

	static function parse_error(m:String):Void {

		trace("SCRIPT ERROR:");
		trace('[Line ${pp+1}] ' +m);
		pp = 100;
		pl = 0;
	}

	static function parse_filterChar(c:String):Bool {

		var cc:Int = c.charCodeAt(0);

		if (cc >= 65 && cc <= 122) 	return true;	// alphabet
		if (cc >= 48 && cc <= 57) 	return true;	// numeric
		if (cc == 45 || cc == 35) 	return true;	// hyphen or hash
		if (cc == 58 || cc == 62) 	return true;	// colon or right arrow
		if (cc == 44)				return true;	// comma ;TODO: 47, fslash for commenting
		return false;
	}
}















































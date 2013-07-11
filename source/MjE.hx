package;

import org.flixel.FlxTypedGroup;
import tmx.TmxObject;

class MjE {

    static inline public var TILESET_LENGTH = 48;

    // Entity GIDs

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

    static public function initialise():Void {

    	parseScript("actors/script.txt");

		players = new FlxTypedGroup<Player>();
		actors 	= new FlxTypedGroup<Actor>();
		events 	= new FlxTypedGroup<Event>();

    	for (o in MjM.map_events.objects) e_switch(o);
    }

    static public var players:FlxTypedGroup<Player>;
    static public var actors:FlxTypedGroup<Actor>;
    static public var events:FlxTypedGroup<Event>;

	static public function e_switch(o:TmxObject):Void {

		o.gid -= TILESET_LENGTH;

		var swi:Int; 	// swtich index
		swi = 0;		// using an index with an eq value to check if escaped ceil bound

		while (swi <= sdi) {

			if (o.gid == s_gids[swi]) break;
			swi++;
		}

		if (swi <= sdi) {

			switch (s_ets[swi]) {

				case E_ACTOR:		actors.add(new Actor(o.x, o.y, o.gid, o.custom.data));
			}
		}

		else if (o.gid <= 32) 		events.add(new Event(o.x, o.y, o.gid, o.custom.data));

		else trace("Warning: Object on map with GID ${o.gid} could not be matched.");
	}

	static public function e_gds(gid:Int):Array<Array<String>> {

		var swi:Int; 	// swtich index
		swi = 0;		// using an index with an eq value to check if escaped ceil bound

		while (swi <= sdi) {

			if (gid == s_gids[swi]) break;
			swi++;
		}

		if (swi > sdi) return null;
		return s_data[swi];
	}

	static public function e_pds(n:String):Array<Array<String>> {

		var swi:Int; 	// swtich index
		swi = 0;		// using an index with an eq value to check if escaped ceil bound
		var c:Bool = false;

		while (swi <= sdi) {

			if (s_ets[swi] != E_PROJECTILE) {

				swi++;
				continue;
			}
			
			for (p in s_data[swi][C_PROPERTIES]) if (p == 'name:$n') c = true;
			if (c) break;
			swi++;
		}

		if (swi > sdi) return null;
		return s_data[swi];
	}

	static var ps:Bool = true;		// Parse Saftey, don't let script parse twice
	static var pv:Int;	 			// Parse Level: filter, entity, component, property, value
	static var pp:Int;				// Parse Pointer, counter for line
	static var pl:Int;				// Parse Length, length of index array
	static var pa:Array<String>;	// Parse Array, of lines
	//static var ta:Actor;			// Temp Actor

	static var s_data:Array<Array<Array<String>>>;	// Index, component, properties with values
	static var s_ets:Array<Int>;					// Index, entity types
	static var s_gids:Array<Int>;					// Index, GID

	static var sdi:Int;		// Script Data Index pointer, keyed with script_ets and scripts_gids
	static var sdc:Int;		// Script Data Component pointer
	static var sdp:Int;		// Script Data Property pointer
	
	public static inline var E_ACTOR			:Int = 0;	// Entity Types
	public static inline var E_PROJECTILE		:Int = 1;
	public static inline var E_OBSTACLE			:Int = 2;
	public static inline var E_DECORATION		:Int = 3;

	public static inline var C_SPRITES 			:Int = 0;	// Component types
	public static inline var C_ANIMATIONS 		:Int = 1;
	public static inline var C_PROPERTIES  		:Int = 2;
	public static inline var C_STATES 			:Int = 3;

			static inline var V_FILTER 			:Int = 0;	// Parse Level, for pv
			static inline var V_ENTITY 			:Int = 1;
			static inline var V_COMPONENT  		:Int = 2;
			static inline var V_PROPERTY 		:Int = 3;

	static public function parseScript(f:String):Void {

		//if (ps) return;
		//ps = false;

		s_data = [];
		s_ets = [];
		s_gids = [];

		pp = 0;
		pv = 0;
	    pa = openfl.Assets.getText('assets/$f').split("\n");
	    pl = pa.length;

	    sdi = -1;	// pre-increments on actors
	
		while (pp < pl) {

			//trace('sdi:$sdi    pp:$pp    pl:$pl');

			if (pv==V_FILTER) {				// Filter everything through p_filterChar

				var tl:String = "";			// Temp Line
				var tc:String;				// Temp Char
				var c:Int = 0;				// Counter
				var l:Int = pa[pp].length;	// Last

				while (c < l) {

					tc = pa[pp].charAt(c);
					if (p_filterChar(tc)) tl += tc.toLowerCase();
					c++;
				}

				pa[pp] = tl;

				if (pp+1 == pl) {

					pv++;
					pp = 0;
					continue;
				}
			}

			else if (pa[pp]=="") null;		// Empty line, ignore

			else if (pv==V_ENTITY) {		// Identify an entity (actor, projectile, obstacle, decoration)

				if (pa[pp+1].substr(0,3)=="---" && p_entAssert(pa[pp])) {

					sdi++;				// add new actor
					s_data[sdi] = [];	// clear Script Data at current index
					p_ent(pa[pp]);		// do the stuff
					pp++; 				// skip past the hyphen line
					pv++;				// level up

					s_data[sdi][C_SPRITES] 		= [];
					s_data[sdi][C_ANIMATIONS] 	= [];
					s_data[sdi][C_PROPERTIES] 	= [];
					s_data[sdi][C_STATES] 		= [];
				}
				
				else parse_error("Could not assert instruction [OR] Object definition invalid (have you added hyphens under it?)");
			}

			else if (pv==V_COMPONENT) {

				if (p_compAssert(pa[pp])) {

					p_comp(pa[pp]);			// assign current comp in SDC
					s_data[sdi][sdc] = [];	// clear current comp
					sdp = -1;				// reset properties pointer
					pv++;
				}

				else if (p_entAssert(pa[pp])) {

					pv--;
					continue;
				}

				else parse_error("Component definition invalid (two dashes and either sprites, properties, etc)");
			}

			else if (pv==V_PROPERTY) {

				if (p_propAssert(pa[pp])) {

					 sdp++;
					 p_prop(pa[pp]);
				}


				else if (p_compAssert(pa[pp]) || p_entAssert(pa[pp])) {

					pv--;
					continue;
				}

				else parse_error("Bad property/value assignment (syntax is usually \"property: value[, value, etc]\")");
			}


			pp++;
		}

		//trace('sdi:$sdi    pp:$pp    pl:$pl');

		/*sdi = 0;
		sdc = 0;
		sdp = 0;

		while (sdi < s_data.length) {
	
			trace("OBJECT");
			trace("------");
			trace("INDEX: " +sdi);

			sdc = 0;

			while (sdc < s_data[sdi].length) {

				trace("COMP_" +sdc);

				sdp = 0;

				while (sdp < s_data[sdi][sdc].length) {

					trace(" + " +s_data[sdi][sdc][sdp]);
					sdp++;
				}

				sdc++;
			}

			sdi++;
		}*/

	}

	static function p_prop(s:String):Void {

		//trace(s);

		while (pp+1!=pl && pa[pp+1].substr(0,1)==">") {

			pp++;
			s += pa[pp];
		}

		s_data[sdi][sdc][sdp] = s;
	}

	static function p_propAssert(s:String):Bool {

		var ci:Int = s.indexOf(":");
		var ss:String = s.substr(0, ci);

		if (ci != -1 && ss == ss.toLowerCase()) return true;
		return false;
	}

	static function p_comp(s:String):Void {

		if 		(s.substr(2)=="sprites") 		sdc = C_SPRITES;
		else if (s.substr(2)=="properties") 	sdc = C_PROPERTIES;
		else if (s.substr(2)=="animations") 	sdc = C_ANIMATIONS;
		else if (s.substr(2)=="states") 		sdc = C_STATES;
		else parse_error("No valid componant definition found (valid are sprites, properties, animation or states)");
	}


	static function p_compAssert(s:String):Bool {

		if (s.substr(0,2)=="##" && s.length > 2) return true;
		return false;
	}

	static function p_ent(s:String):Void {

		p_ets(pa[pp]);							// set the ent type index (is current ent actor, proj? etc)
	
		var sp:Int = s.length -1;				// String Pointer
		var sc:Int = 0;							// String Catch, how many catches

		while (sp >= 0) {

			if (s.charAt(sp) == ",") {

				sc++;
				if (sc==1) p_gids(pa[pp], sp);	// set the GID index (used for ent map numbers)
				else if (sc==2) null;			// ***TODO*** Add the scene to the name 
			}

			sp--;
		}

	}

	static function p_gids(s:String, sp:Int):Void {

		s_gids[sdi] = Std.parseInt(s.substr(++sp));
	}

	static function p_ets(s:String):Void {

		if 		(s.substr(0,5) =="actor") 		s_ets[sdi] = E_ACTOR;
		else if (s.substr(0,10)=="projectile") 	s_ets[sdi] = E_PROJECTILE;
		else if (s.substr(0,8) =="obstacle") 	s_ets[sdi] = E_OBSTACLE;
		else if (s.substr(0,10)=="decoration") 	s_ets[sdi] = E_DECORATION;
		else parse_error("No valid object definition found (valid are actor, projectile, obstacle or decoration)");
	}

	static function p_entAssert(s:String):Bool {

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

	static function p_filterChar(c:String):Bool {

		var cc:Int = c.charCodeAt(0);

		if (cc >= 65 && cc <= 122) 	return true;	// alphabet
		if (cc >= 48 && cc <= 57) 	return true;	// numeric
		if (cc == 45 || cc == 35) 	return true;	// hyphen or hash
		if (cc == 58 || cc == 62) 	return true;	// colon or right arrow
		if (cc == 44)				return true;	// comma ;TODO: 47, fslash for commenting
		return false;
	}
}















































package;

import org.flixel.*;
import map.*;
import obj.*;
import tmx.*;

class MjO {

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

	static public function switchObject(o:TmxObject):Void {

		o.gid -= TILESET_LENGTH;

		var gameEvents:FlxGroup = PlayState.get_gameEvents();
		var gameObjects:FlxGroup = PlayState.get_gameObjects();

		switch (o.gid) {
			
			case PLAYER_START:
				player = new Player(o);
				gameObjects.add(player);

			case TRIGGER, PLAYER_EXIT:
				gameEvents.add(new MapTrigger(o));



			case TARGET, PATROL_POINT:
				gameEvents.add(new MapTarget(o));




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

	static public function get_player():Player {

		return player;
	}
}
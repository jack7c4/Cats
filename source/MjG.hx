package;

import org.flixel.*;
import org.flixel.util.*;
import tmx.*;
import haxe.xml.Fast;

class MjG {

	static private var gameMap:FlxTilemap;
	static private var events:Array<Dynamic>;
	static private var objects:Array<Dynamic>;
	static private var defaultTmxObj:TmxObject;
	static private var gameStarted:Bool = false; // currently only used to protect addObject

	static public function initialise():Void {

		gameMap = getMap();
		initialiseEvents();
		initialiseObjects();

		gameStarted = true;
	}

	static public function started():Bool {

		return gameStarted;
	}

	static public function setDefaultTmxObj():Void {

		var ttt = new Fast(Xml.parse('
			  <object gid="66" x="484" y="286">
			   <properties>
			    <property name="sequence" value="4"/>
			    <property name="tag" value="1"/>
			   </properties>
			  </object>'));

		defaultTmxObj = new TmxObject(ttt.node.object, PlayState.get_gameMapTmx().getObjectGroup("events"));
	}





	// Getters

	static public function getMap():FlxTilemap {

		return PlayState.get_gameMap();
	}

	static public function getEventsGroup():FlxGroup {

		return PlayState.get_gameEvents();
	}

	static public function getObjectsGroup():FlxGroup {

		return PlayState.get_gameObjects();
	}

	static public function getPlayer():Player {

		return MjO.get_player();
	}

	static public function getPlayerMidpoint():FlxPoint {

		return MjO.get_player().getMidpoint();
	}






	// Initialisers

	static public function initialiseEvents():Void {
		
		events = untyped getEventsGroup().members;
		//trace('Prepping ${events} event members');

		////trace("Tag " +tag +"...");

		var retEvents:Array<Dynamic> = [];

		for (e in events) if (e!=null) retEvents.push(e);

		//trace('Got ${retEvents.length} events members');

		events = retEvents;
	}

	static public function initialiseObjects():Void {

		objects = untyped getObjectsGroup().members;
		//trace('Prepping ${objects} object members');

		var retObjects:Array<Dynamic> = [];

		for (o in objects) if (o!=null) retObjects.push(o);
		//trace('Got ${retObjects.length} object members');

		objects = retObjects;
	}






	// OnLoad list

	static private var onLoadList:Array<Void -> Void>;

	static public function initialiseOnLoad():Void onLoadList = [];

	static public function addOnLoad(f:Void -> Void):Void onLoadList.push(f);

	static public function executeOnLoad():Void for (f in onLoadList) f();






	// Engine functions

	static public function calculateVelocity(source:FlxPoint, target:FlxPoint, speed:Int):FlxPoint {

		var angle = FlxAngle.getAngle(source, target) -90;
        var x = Math.cos(angle * (Math.PI / 180));
        var y = Math.sin(angle * (Math.PI / 180));
       
       	return new FlxPoint(x *speed, y *speed);
	}

	static public function sortZ(g:Dynamic):Void {

		g.members.sort(function(a:Dynamic, b:Dynamic) {
			if (a.y > b.y) return 1;
			else if (a.y <  b.y) return -1;
			else return 0;
			});
	}

	static public function getLastObject():Dynamic {

		// if adding directly to the objects list make sure initilse objects has been called!
		return objects[objects.length-1];
	}

	static public function addObject(o:Dynamic):Void {

		if (!gameStarted) getObjectsGroup().add(o);
	}






	// Game functions

	static public function getEvents(tag:Int):Array<Dynamic> {

		var retEvents:Array<Dynamic> = [];

		if (tag==0) return events;
		
		else for (e in events) if (e.tag==tag) retEvents.push(e);
		return retEvents;

	}

	static public function getObjects(tag:Int):Array<Dynamic> {

		var retEvents:Array<Dynamic> = [];

		if (tag==0) return events;
		
		else for (e in objects) if (e.tag==tag) retEvents.push(e);
		return retEvents;

	}

	static public function getEvent(name:String):Dynamic {

		for (e in events) if (e.name==name) return e;
		return null;
	}

	static public function getEventByTag(tag:Int):Dynamic {

		for (e in events) if (e.tag==tag) return e;
		for (o in objects) if (o.tag==tag) return o;
		return null;
	}

	static public function spawnObject(o:Int, x:Float, y:Float):Dynamic {

		if (o<=32) return null; // not applicable because it's an event, not an object
		if (defaultTmxObj==null) setDefaultTmxObj();

		defaultTmxObj.gid = o + MjO.TILESET_LENGTH;
		defaultTmxObj.x = Std.int(x);
		defaultTmxObj.y = Std.int(y);
		MjO.switchObject(defaultTmxObj);

		MjG.initialiseObjects(); // add it to flixel group AND MjG
		return MjG.getLastObject();
	}

	static public function activateEvents(tag:Int, state:Int = 0):Void {

		for (e in events) if (e.tag==tag && e.gid!=MjO.TRIGGER && e.gid!=MjO.PLAYER_EXIT) e.activate(state);
		for (o in objects) if (o.tag==tag) o.activate(state);
	}

	static public function switchTile(target:FlxPoint, arg:Int = 0, reverse:Bool = false) {

		var tx:Int = Std.int(target.x / 16);
		var ty:Int = Std.int(target.y / 16);
		var alt:Int = (reverse) ? -1 : 1;

		gameMap.setTile(tx, --ty, gameMap.getTile(tx, ty) +alt);
		if (arg==1) gameMap.setTile(tx, ++ty, gameMap.getTile(tx, ty) +alt);
	}

	static public function switchTileBack(target:FlxPoint, arg:Int = 0) {

		switchTile(target, arg, true);
	}
}
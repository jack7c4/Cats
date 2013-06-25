package;

import openfl.Assets;
import flash.geom.Rectangle;
import flash.net.SharedObject;
import org.flixel.*;
import tmx.*;
import map.*;
import obj.*;

class PlayState extends FlxState {

	private static var player:Player;

	private static var gameMap:FlxTilemap;
	private static var gameMapTmx:TmxMap;
	private static var gameEvents:FlxGroup;
	private static var gameObjects:FlxGroup;

	override public function create():Void {

		#if !neko
		FlxG.bgColor = 0xff131c1b;
		#else
		//FlxG.camera.bgColor = {rgb: 0x131c1b, a: 0xff};
		#end		
		#if !FLX_NO_MOUSE
		//FlxG.mouse.show();
		#end

		// Prepare current game state

		gameMap = new FlxTilemap();
		gameEvents = new FlxGroup();
		gameObjects = new FlxGroup();


		// Prepare the onload list, so functions can be called after the playstate

		MjG.initialiseOnLoad();


		// Read MjM for level information

		MjM.initialise();

		var cm:String = MjM.getCurrentMap();
		var cs:String = MjM.getCurrentScene();
		gameMapTmx = new TmxMap(openfl.Assets.getText('assets/maps/$cm.tmx'));

		gameMap.loadMap(
				gameMapTmx.getLayer('main').toCsv(gameMapTmx.getTileSet('main')),
				'assets/maps/$cs-tiles.png', 16, 16, FlxTilemap.OFF, 0, 0, 24);

		add(gameMap);


		// Add events (and objects) to Flixel groups

		var objectsEvents:TmxObjectGroup = gameMapTmx.getObjectGroup("events");
		for (o in objectsEvents.objects) MjO.switchObject(o);


		// Prepare events and objects in MjG

		MjG.initialise();


		// Reference player from MjO

		player = MjO.get_player();


		// Add groups to map

		gameEvents.visible = false;
		add(gameEvents);
		add(gameObjects);


		// Add camera

		FlxG.camera.setBounds(0, 0, gameMap.width, gameMap.height, true);
		FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN);


		// Call blocked functions and run maps' intro script

		MjG.executeOnLoad();
		MjM.startEvents();

		// Null test
		//var test = MjG.getEvents();
		//for (t in test) if (true) trace(t.gid);
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void {

		if (FlxG.keys.justPressed("ENTER")) 	MjM.restartLevel();
		else if (FlxG.keys.justPressed("P")) 	MjM.nextLevel();
		else if (FlxG.keys.justPressed("O")) 	MjM.prevLevel();

		super.update();

		MjG.sortZ(gameObjects);
		FlxG.collide(gameObjects, gameMap);
		FlxG.collide(player, gameObjects);
		FlxG.overlap(player, gameEvents, collidePlayerEvents);
	}

	private function collidePlayerEvents(a:Player, b:Dynamic):Void {

		if (b.gid!=MjO.TRIGGER && b.gid!=MjO.PLAYER_EXIT) return;
		if (!b.active) return;

		b.activate();
	}

	static public function get_gameMap():FlxTilemap {

		return gameMap;
	}

	static public function get_gameMapTmx():TmxMap {

		return gameMapTmx;
	}

	static public function get_gameEvents():FlxGroup {

		return gameEvents;
	}

	static public function get_gameObjects():FlxGroup {

		return gameObjects;
	}
}
package;

import org.flixel.*;
import tmx.*;
import obj.*;

class Player extends FlxSprite {

    public var freeze:Bool = false;

    private var speed_walk:Int = 60;
    private var speed_sprint:Int = 140;

    override public function new(x:Float, y:Float) {

        super(x, y);

        loadGraphic("assets/sprites/player.png", true, true, 28, 28);
        
        addAnimation("stand", [0], 0, false);
        addAnimation("walk", [8,9,10,11], 4);
        addAnimation("sprint", [4,5,6,7], 9);

        width = 10;
        height = 12;
        offset.y = 15;
        offset.x = 8;

        mass = 0;

        play("stand");
    }

    override public function update():Void {

        this.velocity.x = 0;
        this.velocity.y = 0;

        if (!freeze) {


            if (FlxG.keys.UP || FlxG.keys.DOWN || FlxG.keys.LEFT || FlxG.keys.RIGHT) {

                if (FlxG.keys.RIGHT) {

                    velocity.x = speed();
                    facing = FlxObject.LEFT;
                }
                else if (FlxG.keys.LEFT) {

                    velocity.x = -speed();
                    facing = FlxObject.RIGHT;
                }

                if (FlxG.keys.UP) {

                    velocity.y = -speed();
                }
                else if (FlxG.keys.DOWN) {

                    velocity.y = speed();
                }
            }
            else play("stand");
        }

        super.update();
    }

    private function speed():Int {

        if (FlxG.keys.C) return state_sprint();
        return state_walk();
    }

    private function state_walk():Int {

        play("walk");
        return speed_walk;
    }

    private function state_sprint():Int {

        play("sprint");
        return speed_sprint;
    }
}


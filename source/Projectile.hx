package;

import org.flixel.FlxSprite;
import org.flixel.util.FlxVelocity;
import org.flixel.util.FlxPoint;
import org.flixel.util.FlxMath;

class Projectile extends FlxSprite {

    override public function new(x:Float, y:Float, d:FlxPoint, p:String, s:Int):Void {

        super(x +6, y +6);
        width = 2;
        height = 2;

        var ds:Array<Array<String>> = MjE.e_pds(p);

        parse_sprites       (ds[MjE.C_SPRITES]);
        parse_properties    (ds[MjE.C_PROPERTIES]);

        FlxVelocity.moveTowardsPoint(this, d, speed *32);
    }

    var name:String;
    var speed:Int;

    function switch_properties(ps:Map<String, String>):Void {

        for (k in ps.keys()) {

            switch (k) {
                
                case "name":     name = ps[k];
                case "speed":   speed = Std.parseInt(ps[k]);   
            }
        }
    }

    function p_gk(s:String):String {    // Parse, Get Key

        for (i in 0...s.length-1) if (s.charAt(i) == ":") return s.substr(0, i);
        return "";

    }

    function p_gv(s:String):String {    // Parse, Get Value

        for (i in 0...s.length-1) if (s.charAt(i) == ":") return s.substr(i+1, s.length);
        return "";
    }

    function p_gvxw(s:String):Int {   // Parse, Get Value, Dimension Width

        s = p_gv(s);
        for (i in 0...s.length-1) if (s.charAt(i) == "x") return Std.parseInt(s.substr(0, i));
        return 0;
    }

    function p_gvxhs(s:String):String {   // Parse, Get Value, Dimension Width

        s = p_gv(s);
        for (i in 0...s.length-1) if (s.charAt(i) == "x") return s.substr(i+1, s.length);
        return "";
    }

    function p_gvxh(s:String):Int {   // Parse, Get Value, Dimension Height

        s = p_gv(s);
        for (i in 0...s.length-1) if (s.charAt(i) == "x") return Std.parseInt(s.substr(i+1, s.length));
        return 0;
    }

    function parse_sprites(cs:Array<String>):Void {

        var dw:Int = 0;     // Dimension Width
        var dh:Int = 0;     // Dimension Height
        var dn:String = ""; // Dimension Name

        for (s in cs) {

            switch (p_gk(s)) {

                case "dimensions":
                    dw = p_gvxw(s);
                    dh = p_gvxh(s);

                case "spritesheet":
                    dn = p_gv(s);
            }
        }

        if (dn != "") 
        
        this.loadGraphic('assets/sprites/$dn.png');

        else p_e("Invalid required sprite values");
    }

    function p_e(s:String):Void {

        trace("PROJECTILE ERROR:");
        trace('[PROJ $name] $s');
    }

    function parse_properties(cs:Array<String>):Void {

        var ps:Map<String, String> = new Map<String, String>();
        for (s in cs) ps[p_gk(s)] = p_gv(s);
        switch_properties(ps);
    }

    var t_timer:Int = 0;

    override public function update():Void {

        t_timer++;

        super.update();

        if (FlxMath.distanceBetween(MjE.players.members[0], this) < 12 || t_timer > 60) {
            
            if (t_timer < 60)   MjM.level_restart();

            this.kill();
            this.destroy();
        }
    }
}
package;

import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.util.FlxPoint;
import org.flixel.util.FlxMath;
import org.flixel.util.FlxVelocity;

private typedef Frame = {

    var d:Int;          // duration
    var a:Void -> Void; // action
}

class Actor extends FlxSprite {

    public static inline var IDLE:Int 		= 2;
    public static inline var SEEK:Int 		= 3;
    public static inline var PATROL:Int     = 5;
    public static inline var SHOOT:Int      = 7;

	       var states:Array<Array<Frame>>;
    public var state:Int;
           var target:FlxSprite;

    override public function new(x:Float, y:Float, gid:Int, ?ps:Map<String, String>):Void {

        super(x, y);

        this.active = true;
        this.gid = gid;
        target = null;

        var ds:Array<Array<String>> = MjE.e_gds(gid);

        parse_sprites       (ds[MjE.C_SPRITES]);
        parse_animations    (ds[MjE.C_ANIMATIONS]);
        parse_properties    (ds[MjE.C_PROPERTIES]);
        switch_properties   (ps);
        parse_states        (ds[MjE.C_STATES]);

        state_change(IDLE);

        // FlxG.watch(this, "state");
        // FlxG.watch(this, "fp");
        // FlxG.watch(this, "fl");
        // FlxG.watch(this, "dp");
        // FlxG.watch(this, "dl");
    }

    public var tag:Int;
    public var gid:Int;
    public var action:String;
    public var method:String;
           var repeat:Bool;
           var speed:Int           = 4;
           var lookdistance:Int    = 128;
           var shootrange:Int      = 64;

    function switch_properties(ps:Map<String, String>):Void {

        for (k in ps.keys()) {

            switch (k) {
                
                case "speed":        speed = Std.parseInt(ps[k]);
         case "lookdistance": lookdistance = Std.parseInt(ps[k]);
           case "shootrange":   shootrange = Std.parseInt(ps[k]);

                   case "tag":     tag = Std.parseInt(ps[k]);
                case "action":  action = ps[k];
                case "method":  method = ps[k];
                case "repeat":  repeat = (ps[k]=="true") ? true : false;
                case "active":  active = (ps[k]=="true") ? true : false;
            }
        }
    }








    // Parsing

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

        if (p_as(dw, dh, dn)) 
        
        this.loadGraphic('assets/sprites/$dn.png', true, true, dw, dh);

        else p_e("Invalid required sprite values");
    }

    function p_as(dw:Int, dh:Int, dn:String):Bool {

        return dw != 0 && dh != 0 && dn != "";
    }

    function p_e(s:String):Void {

        trace("ACTOR ERROR:");
        trace('[GID $gid] $s');
    }

    function parse_animations(cs:Array<String>):Void {

        var an:String;      // Animation Name
        var afs:Array<Int>; // Animation Frames
        var ax:Bool;        // Animation Stop

        for (s in cs) {

            an = p_gk(s);
            ax = (s.charAt(s.length-1) == "x") ? true : false;
            if (ax) s = s.substr(0, s.length-1);
            afs = p_gvafs(s);

            this.addAnimation(an, afs, 6, !ax);
        }
    }

    function p_gvafs(s:String):Array<Int> {

        s = p_gv(s);
        var afs:Array<Int> = [];
        for (af in s.split(",")) afs.push(Std.parseInt(af));
        return afs;
    }

    function parse_properties(cs:Array<String>):Void {

        var ps:Map<String, String> = new Map<String, String>();
        for (s in cs) ps[p_gk(s)] = p_gv(s);
        switch_properties(ps);
    }

    function parse_states(cs:Array<String>):Void {

        states = [];
        for (s in cs) states[p_gks(s)] = p_gvsc(s);
    }

    function p_gvsc(s:String):Array<Frame> {

        var fs:Array<Frame> = [];
        s = p_gv(s);
        
        for (f in s.split(">")) if (f != "") fs.push({d:p_gvscfd(f), a:p_gvscfa(f)});
        
        return fs;
    }

    function p_gvscfa(s:String):Void->Void {

        var cs:Array<String> = s.split("");
        s = "";
        
        for (c in cs) {
            var cc:Int = c.charCodeAt(0);
            if (cc >= 97 && cc <= 122) s += c;
        }

        switch (s) {

            case "look":    return idle_look;
            case "target":  return seek_target;
            case "aim":     return shoot_aim;
            case "attack":  return shoot_attack;

            case "loop":        return d_loop;
            case "gotoseek":    return d_goto_seek;
        }

        return d_null;
    }

    function p_gvscfd(s:String):Int {

        var cs:Array<String> = s.split("");
        var dstr:String = "";

        for (c in cs) {

            var cc:Int = c.charCodeAt(0);
            
            if (cc >= 48 && cc <= 57) dstr += c;
            else break;
        }

        if (dstr == "") return 0;
        else return Std.parseInt(dstr);
    }

    function p_gks(s:String):Int {

        switch (p_gk(s)) {

            case "idle":    return IDLE;
            case "seek":    return SEEK;
            case "patrol":  return PATROL;
            case "shoot":   return SHOOT;
        }

        return 0;
    }











    // Update, AI, states, cool shit

    var dp:Int;     // (duration pointer)   position of time against the frame's duration
    var dl:Int;     // (duration last)      the current frame's duration
                    // the current state is defined in MapEvent.state:Int (Ai extends ObjMain which extends MapEvent)
    var fp:Int;     // (frame pointer)      position of curret state's next frame
    var fl:Int;     // (frame last)         position of current state's last frame

    override public function update():Void {

        velocity.x = 0;
        velocity.y = 0;

        if (!active) return;
        if (fp > fl) d_loop();
        if (dp==dl) f_update();
        dp++;

        move_update();
        super.update();

    }

    function f_update():Void {

        var f:Frame = states[state][fp];

        f.a();
        dl = f.d *5;

        dp = 0;
        fp++;
    }

    function state_change(state:Int) {

        move_target = null;
        this.state = state;
        fp = 0;
        fl = states[state].length -1;
        
        f_update();
    }


    // Moving, internal functions

    var move_target:FlxPoint;

    function move_update():Void {

        if (move_target == null) return;

        if (FlxMath.distanceToPoint(this, move_target) < 8) {

            move_target = null;
            return;
        }

        FlxVelocity.moveTowardsPoint(this, move_target, speed *8);
    }



    // state Direction functions

    function d_null():Void {

        null;
    }

    function d_loop():Void {

        state_change(state);
    }

    function d_goto_seek():Void {

        state_change(SEEK);
    }









    // Action functions

    function idle_look():Void {

        play("stand");
        for (p in MjE.players.members) if (MjU.getDistanceV(p, this) < lookdistance) state_change(SEEK);
    }

    function seek_target():Void {

        target = MjE.players.members[0];
        
        if (target == null) {

            move_target = null;
            state_change(IDLE);
            return;
        }
        
        play("walk");
        move_target = MjU.getPosV(target);

        if (MjU.getDistanceV(this, target) < shootrange) state_change(SHOOT);
        else if (MjU.getDistanceV(this, target) < 8) state_change(IDLE);
    }


    var shoot_target:FlxPoint;

    function shoot_aim():Void {
    
        play("aim");
        shoot_target = MjU.getPosV(target);
    }

    function shoot_attack():Void {

        play("shoot");
        shoot_target = MjU.getPosV(target);
        var bullet = new Projectile(x, y, shoot_target, "red", 32);
        FlxG.state.add(bullet);
    }

}




































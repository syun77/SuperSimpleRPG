package ;

import flixel.system.debug.FlxDebugger.GraphicArrowRight;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.FlxObject;

/**
 * 敵情報
 **/
class MenuEnemy extends FlxObject {

    private var _group:FlxSpriteGroup;
    private var _texts:Map<Int, FlxText>;

    public function new() {
        super();
        _group = new FlxSpriteGroup();
        _texts = new Map<Int, FlxText>();

        var x = FlxG.width*3/4 + 8;
        var y = 64;
        var dy = 12;
        for(id in Enemy.ID_START...Enemy.ID_END) {

            var cnt = cast(FlxG.state, PlayState).getEnemyCount(id);
            if(cnt == 0) {
                continue;
            }

            var spr = new FlxSprite(x-2, y-2);
            spr.loadGraphic(Enemy.getAssetPath(id));
            spr.scale.set(0.8, 0.8);
            _group.add(spr);
            var tx = new FlxText(x+16, y);
            _updateText(tx, id);
            _texts.set(id, tx);
            _group.add(tx);
            y += dy;
        }

        FlxG.state.add(_group);
    }

    public function _updateText(text:FlxText, id:Int):Void {
        var lv:Int = cast(FlxG.state, PlayState).getPlayerLevel();
        var damage = lv - id + 1;
        if(damage < 0) {
            damage = 0;
        }
        text.text = "Lv:" + id + " -> " + damage + "D";
    }

    override function update():Void {
        super.update();


    }
}

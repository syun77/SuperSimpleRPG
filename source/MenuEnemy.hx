package ;

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

    public function new() {
        super();
        _group = new FlxSpriteGroup();

        var tx = new FlxText(100, 100);
        tx.text = "hoge";
        _group.add(tx);

        FlxG.state.add(_group);
    }
}

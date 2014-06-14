package ;

import flixel.util.FlxRandom;
import flixel.FlxSprite;

/**
 * アイテム
 **/
class Item extends FlxSprite {

    public static inline var ID_POWER = 1; // レベルアップ
    public static inline var ID_HEART = 2; // 体力回復
    public static inline var ID_BANANA = 3; // バナナ

    private var _id:Int;

    public function new() {
        super();
    }

    public function vanish() {
        kill();
    }

    public function getId():Int return _id;

    public function init(id:Int, px:Int, py:Int):Void {
        _id = id;
        x = px;
        y = py;
        _loadAsset(_id);
    }

    public function _loadAsset(id:Int):Void {
        switch(id) {
            case ID_POWER: loadGraphic("assets/images/power.png", true);
            case ID_HEART: loadGraphic("assets/images/heart.png", true);
            case ID_BANANA: loadGraphic("assets/images/banana.png", true);
        }

        animation.add("play", [0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1], 2+FlxRandom.intRanged(0, 4));
        animation.play("play");
    }

}

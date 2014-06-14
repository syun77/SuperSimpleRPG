package ;

import flixel.FlxSprite;

/**
 * 鉄球クラス
 **/
class Iron extends FlxSprite {

    public static inline var ID_NORMAL = 0;
    public static inline var ID_GREEN  = 1;
    public static inline var ID_RED    = 2;

    private var _id:Int;

    public function new(id:Int, px:Float, py:Float) {
        super(px, py);
        _id = id;
        switch(_id) {
            case ID_NORMAL: loadGraphic("assets/images/iron.png", true);
        }

        animation.add("play", [0, 1, 2, 3], 6);
        animation.play("play");
    }
}

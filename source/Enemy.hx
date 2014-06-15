package ;

import flixel.util.FlxAngle;
import flixel.util.FlxRandom;
import flixel.FlxSprite;

/**
 * 敵
 **/
class Enemy extends FlxSprite {

    public static inline var ID_SLIME = 1; // スライム
    public static inline var ID_BAT = 2; // コウモリ
    public static inline var ID_GOAST = 3; // オバケ
    public static inline var ID_SNAKE = 4; // ヘビ
    public static inline var ID_DOKURO = 5; // ドクロ

    public static inline var ID_START = ID_SLIME;
    public static inline var ID_END = ID_DOKURO+1;

    private var _id:Int = ID_SLIME;
    private var _timer:Int;

    /**
     * アセットのパスを取得する
     * @param id 敵ID
     * @return アセットのパス
     **/
    static public function getAssetPath(id:Int):String {
        switch(id) {
            case ID_SLIME: return "assets/images/slime.png";
            case ID_BAT:   return "assets/images/bat.png";
            case ID_GOAST: return "assets/images/goast.png";
            case ID_SNAKE: return "assets/images/snake.png";
            case ID_DOKURO: return "assets/images/dokuro.png";
        }

        return "";
    }

    /**
     * コンストラクタ
     **/
    public function new() {
        super();
        //immovable = true;
    }

    /**
     * 消滅
     **/
    public function vanish():Void {
        kill();
    }

    /**
     * レベルを取得する
     * @return レベル
     **/
    public function getLevel():Int { return _id; }

    /**
     * 初期化
     **/
    public function init(id:Int, px:Int, py:Int):Void {
        _id = id;
        x = px;
        y = py;
        _loadAsset(_id);
        _timer = FlxRandom.intRanged(0, 40);
    }

    /**
     * 画像ファイルの読み込み
     **/
    private function _loadAsset(id:Int):Void {
        var path = Enemy.getAssetPath(id);
        loadGraphic(path);
    }

    /**
     * 更新
     **/
    override public function update():Void {

        _timer += FlxRandom.intRanged(1, 2);
        if(_timer%120 < 40) {
            flipX = true;
        }
        else {
            flipX = false;
        }

        switch(_id) {
            case ID_BAT, ID_GOAST, ID_DOKURO:
                offset.y = 2*Math.sin((_timer%180)*FlxAngle.TO_RAD);
        }
    }
}

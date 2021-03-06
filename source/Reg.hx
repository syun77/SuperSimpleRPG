package;

import flixel.util.FlxSave;

class Reg {
    // ステージ最大数
    public static inline var STAGE_MAX = 10;

    // 現在のステージ番号
    public static var stage:Int = 1;
    // 最大のステージ番号
    public static var stageMax:Int = 1;
    // セーブデータ
    private static var _save:FlxSave = null;

    public static var lastPlayMusic:String = "";

    /**
     * ゲームデータをロードする
     **/
    public static function load():Void {

        if(_save == null) {
            _save = new FlxSave();
        }

        // バインド
        _save.bind("SAVEDATA");

        // セーブデータ取り出し
        if(_save.data != null && _save.data.stageMax != null) {
            stageMax = _save.data.stageMax;
        }
    }

    /**
     * ゲームデータをセーブする
     **/
    public static function save():Void {

        if(_save == null) {
            _save = new FlxSave();
        }

        // バインド
        _save.bind("SAVEDATA");

        _save.data.stageMax = stageMax;

        // 書き込み
        _save.flush();
    }

    /**
     * セーブデータを初期化する
     **/
    public static function clear():Void {

        if(_save == null) {
            _save = new FlxSave();
        }

        // バインド
        _save.bind("SAVEDATA");

        _save.erase();
    }

    /**
     * ステージ数を初期化
     **/
    public static function resetStage():Void {
        stage = 1;
    }

    /**
     * 次のステージへ進む
     * @return 次のステージがあればtrue
     **/
    public static function nextStage():Bool {
        stage++;
        if(stage > STAGE_MAX) {
            stage = STAGE_MAX;
            // ゲームクリア
            return false;
        }

        if(stage > stageMax) {
            stageMax = stage;
            save();
        }

        // まだ次がある
        return true;
    }

    /**
     * 全ステージをクリアしたかどうか
     * @return 全ステージクリアしていたらtrue
     **/
    public static function isClearAllStage():Bool {
        if(stage > STAGE_MAX) {
            return true;
        }

        return false;
    }
}
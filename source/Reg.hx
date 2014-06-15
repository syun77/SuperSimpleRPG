package;

import flixel.util.FlxSave;

class Reg {
    // 現在のステージ番号
    public static var stage:Int = 1;
    // 最大のステージ番号
    public static var stageMax:Int = 1;
    // セーブデータ
    private static var _save:FlxSave = null;

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
    }

    /**
     * 次のステージへ進む
     **/
    public static function nextStage():Void {
        stage++;
        if(stage > stageMax) {
            stageMax = stage;
            save();
        }
    }

    /**
     * 全ステージをクリアしたかどうか
     * @return 全ステージクリアしていたらtrue
     **/
    public static function isClearAllStage():Bool {
        return false;
    }
}
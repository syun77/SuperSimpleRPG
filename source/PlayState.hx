package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * メインゲーム
 **/
class PlayState extends FlxState {

    // レベルデータ
    private var _level:TiledLevel;

    override public function create():Void {

        // レベルデータ読み込み
        _level = new TiledLevel("assets/levels/001.tmx");
        // レイヤー登録
        add(_level.backgroundTiles);
        add(_level.foregroundTiles);

        super.create();
    }

    /**
     * 破棄
     **/
    override public function destroy():Void {
        super.destroy();
    }

    /**
     * 更新
     **/
    override public function update():Void {
        super.update();

        if(FlxG.keys.justPressed.ESCAPE) {
            throw "Terminate.";
        }
    }
}
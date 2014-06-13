package;

import flixel.util.FlxColor;
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

    // ゲームオブジェクト
    private var _player:Player;

    override public function create():Void {

        // 背景色設定
        bgColor = FlxColor.SILVER;

        // レベルデータ読み込み
        _level = new TiledLevel("assets/levels/001.tmx");
        // レイヤー登録
        add(_level.backgroundTiles);
        add(_level.foregroundTiles);

        super.create();

        // オブジェクトを配置
        _level.loadObjects(this);
    }

    /**
     * 破棄
     **/
    override public function destroy():Void {
        super.destroy();
    }

    /**
     * プレイヤー登録
     **/
    public function setPlayer(player:Player):Void {
        _player = player;
        add(player);
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
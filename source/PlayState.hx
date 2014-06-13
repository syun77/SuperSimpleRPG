package;

import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;

/**
 * メインゲーム
 **/
class PlayState extends FlxState {

    // レベルデータ
    private var _level:TiledLevel;

    // ゲームオブジェクト
    private var _player:Player;
    private var _enemys:FlxTypedGroup<Enemy>;

    override public function create():Void {

        // 背景色設定
        bgColor = FlxColor.SILVER;

        // レベルデータ読み込み
        _level = new TiledLevel("assets/levels/001.tmx");
        // レイヤー登録
        add(_level.backgroundTiles);
        add(_level.foregroundTiles);

        super.create();

        // 敵グループ生成
        _enemys = new FlxTypedGroup<Enemy>();
        add(_enemys);

        // オブジェクトを配置
        _level.loadObjects(this);

//        FlxG.debugger.drawDebug = true;
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
    public function createPlayer(px:Float, py:Float):Void {
        _player = new Player(px, py);
        add(_player);
    }

    /**
     * 敵の生成
     **/
    public function addEnemy(id:Int, px:Int, py:Int):Void {
        var e:Enemy = _enemys.recycle(Enemy);
        e.init(id, px, py);
    }

    /**
     * 更新
     **/
    override public function update():Void {
        super.update();

        if(FlxG.keys.justPressed.ESCAPE) {
            throw "Terminate.";
        }

        if(_level.collideWithLevel(_player)) {
            // 衝突したので停止要求を送る
            _player.requestStop();
        }
    }
}
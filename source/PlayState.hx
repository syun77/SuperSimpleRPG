package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.ui.FlxBar;
import flixel.text.FlxText;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;

/**
 * メインゲーム
 **/
class PlayState extends FlxState {

    // ■定数
    private static inline var TIMER_HP_BAR:Int = 100;

    // レベルデータ
    private var _level:TiledLevel;

    // ゲームオブジェクト
    private var _player:Player;
    private var _enemys:FlxTypedGroup<Enemy>;
    private var _items:FlxTypedGroup<Item>;

    // テキスト
    private var _txHp:FlxText;
    private var _txLevel:FlxText;
    private var _txStage:FlxText;

    // バー
    private var _barHp:FlxBar;
    private var _hpPrev:Float;
    private var _hpNext:Float;
    private var _hpTimer:Float;

    override public function create():Void {

        // 背景色設定
        bgColor = FlxColor.SILVER;

        // ステータス背景
        var waku = new FlxSprite(240, 0);
        waku.makeGraphic(80, 240, FlxColor.BLACK);
        add(waku);

        // レベルデータ読み込み
        {
            var stage = TextUtil.fillZero(Reg.stage+1, 3);
            var path = "assets/levels/" + stage + ".tmx";
            _level = new TiledLevel(path);
        }
        // レイヤー登録
        add(_level.backgroundTiles);
        add(_level.foregroundTiles);

        super.create();

        // 敵グループ生成
        _enemys = new FlxTypedGroup<Enemy>();
        add(_enemys);

        // アイテムグループ生成
        _items = new FlxTypedGroup<Item>();
        add(_items);

        // オブジェクトを配置
        _level.loadObjects(this);

        // テキスト生成
        {
            var X = 240 + 4;
            var py:Int = 4;
            var DY:Int = 12;
            // テキスト
            _txStage = new FlxText(X, py);
            _txStage.text = "Stage: " + (Reg.stage + 1);
            py += DY;
            _txLevel = new FlxText(X, py);
            py += DY;
            _txHp = new FlxText(X, py);
            // HPバー
            _barHp = new FlxBar(X, py+DY, FlxBar.FILL_LEFT_TO_RIGHT, 80-8*2, 4);
            add(_barHp);

            add(_txStage);
            add(_txHp);
            add(_txLevel);

        }

        // HPバー
        _hpPrev = _player.getHpRatio();
        _hpNext = _player.getHpRatio();
        _hpTimer = 0;


        // デバッグ処理
        _player.setHp(10);
//        FlxG.debugger.drawDebug = true;
        FlxG.debugger.toggleKeys = ["ALT"];
        FlxG.watch.add(this, "_hpPrev");
        FlxG.watch.add(this, "_hpNext");
        FlxG.watch.add(this, "_hpTimer");
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
     * アイテムの生成
     **/
    public function addItem(id:Int, px:Int, py:Int):Void {
        var i:Item = _items.recycle(Item);
        i.init(id, px, py);
    }

    /**
     * 更新
     **/
    override public function update():Void {
        super.update();

        // カベとの衝突判定
        if(_level.collideWithLevel(_player)) {
            // 衝突したので停止要求を送る
            _player.requestStop();
        }

        // 敵との衝突判定
        FlxG.overlap(_player, _enemys, _vsPlayerEnemy, _collidePlayerEnemy);

        _updateText();

        //#if !FLX_NO_DEBUG
        if(FlxG.keys.justPressed.ESCAPE) {
            throw "Terminate.";
        }

        if(FlxG.keys.justPressed.F) {
            _player.addHp(1);
        }
        else if(FlxG.keys.justPressed.D) {
            _player.damage(1);
        }
        //#end
    }

    private function _collidePlayerEnemy(obj1:FlxObject, obj2:FlxObject):Bool {
        if(obj1.x == obj2.x && obj1.y == obj2.y) {

            return true; // 衝突している
        }

        return false; // 衝突していない
    }

    /**
     * プレイヤーと敵との衝突
     **/
    private function _vsPlayerEnemy(player:Player, enemy:Enemy):Void {


        var lvP = player.getLevel();
        var lvE = enemy.getLevel();
        if(lvP > lvE) {

            // ダメージなし
        }
        else {
            var diff = lvE - lvP;
            var val = diff + 1; // レベル差 + 1 のダメージ
            player.damage(val);
        }

        // 敵消滅
        enemy.vanish();
    }

    /**
     * テキストの更新
     **/
    private function _updateText():Void {
        _txLevel.text = "Level: " + _player.getLevel();
        _txHp.text = "Hp: " + _player.getHp() + "/" + _player.getHpMax();
        switch(_player.getHpRatio()) {
        case 0: _txHp.color = FlxColor.RED;
        case a if(a <= 0.3): _txHp.color = FlxColor.YELLOW;
        default: _txHp.color = FlxColor.WHITE;
        }

        // HPバー更新
        var now = _player.getHpRatio();
        if(now != _hpPrev ||(now == _hpPrev && now != _hpNext)) {

            if(_hpTimer == 0 || now != _hpNext) {
                // バー減少演出開始
                _hpPrev = _hpNext;
                _hpTimer = TIMER_HP_BAR;
                _hpNext = _player.getHpRatio();
            }
            else {
                // バー減少演出中
                _hpTimer *= 0.9;
                if(_hpTimer <= 1) {
                    _hpPrev = _player.getHpRatio();
                    _hpTimer = 0;
                }

            }
            // 演出中
            var d = now - _hpPrev;
            var d2 = d * (TIMER_HP_BAR - _hpTimer) / TIMER_HP_BAR;
            var val = _hpPrev + d2;
            _barHp.percent = val * 100;
        }
        else {
            // 普通に更新
            _barHp.percent = _player.getHpRatio()*100;
        }
    }
}

package;

import EffectText;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.ui.FlxBar;
import flixel.text.FlxText;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;

/**
 * 状態
 **/
private enum State {
    Init; // 初期化
    Main; // メイン
    StageclearInit; // ステージクリア・初期化
    StageclearMain; // ステージクリア・メイン
    GameoverInit; // ゲームオーバー・初期化
    GameoverMain; // ゲームオーバー・メイン
}

/**
 * メインゲーム
 **/
class PlayState extends FlxState {

    // ■定数
    private static inline var TIMER_HP_BAR = 100;
    private static inline var TIMER_GAMEOVER_INIT = 30;
    private static inline var TIMER_STAGECLEAR_INIT = 30;

    // レベルデータ
    private var _level:TiledLevel;

    // ゲームオブジェクト
    private var _player:Player;
    private var _goal:Goal;
    private var _enemys:FlxTypedGroup<Enemy>;
    private var _items:FlxTypedGroup<Item>;
    private var _effecttext:FlxTypedGroup<EffectText>;
    private var _irons:FlxTypedGroup<Iron>;

    // エミッタ
    private var _emitterEnemy:EmitterEnemy;
    private var _emitterPlayer:EmitterPlayer;

    // テキスト
    private var _txHp:FlxText;
    private var _txLevel:FlxText;
    private var _txStage:FlxText;
    private var _txSubMessage:FlxText;

    // バー
    private var _barLv:StatusBar;
    private var _barHp:StatusBar;

    // ゲーム制御
    private var _state:State = State.Init;
    private var _timer:Int = 0;

    override public function create():Void {

        // 背景色設定
        bgColor = FlxColor.SILVER;

        // ステータス背景
        var waku = new FlxSprite(240, 0);
        waku.makeGraphic(80, 240, FlxColor.BLACK);
        add(waku);

        // レベルデータ読み込み
        {
            var stage = TextUtil.fillZero(Reg.stage, 3);
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

        // 鉄球グループ生成
        _irons = new FlxTypedGroup<Iron>();
        add(_irons);

        // オブジェクトを配置
        _level.loadObjects(this);
        // プレイヤーはこのタイミングでアタッチする
        add(_player);

        // テキストエフェクトグループ生成
        _effecttext = new FlxTypedGroup<EffectText>(8);
        for(i in 0..._effecttext.maxSize) {
            _effecttext.add(new EffectText());
        }
        add(_effecttext);
        Player.s_text = _effecttext;

        // エミッタ生成
        _emitterEnemy = new EmitterEnemy();
        _emitterPlayer = new EmitterPlayer();
        add(_emitterEnemy);
        add(_emitterPlayer);
        Player.s_emiiter = _emitterPlayer;

        // テキスト生成
        {
            var X = 240 + 4;
            var py:Int = 4;
            var DY:Int = 12;
            // テキスト
            _txStage = new FlxText(X, py);
            _txStage.text = "Stage: " + Reg.stage;
            py += DY;
            _txLevel = new FlxText(X, py);
            py += DY;
            _barLv = new StatusBar(X, py, 80-8*2, 4);
            py += 8;
            _txHp = new FlxText(X, py);
            // HPバー
            _barHp = new StatusBar(X, py+DY, 80-8*2, 4);
            add(_barLv);
            add(_barHp);

            add(_txStage);
            add(_txHp);
            add(_txLevel);

        }

        // ゲーム制御変数の初期化
        _state = State.Init;
        _timer = 0;


        // デバッグ処理
        _player.setHp(10);
//        FlxG.debugger.drawDebug = true;
        FlxG.debugger.toggleKeys = ["ALT"];
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
//        add(_player);
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
     * ゴールの生成
     **/
    public function addGoal(px:Int, py:Int):Void {
        _goal = new Goal(px, py);
        add(_goal);
    }

    /**
     * 鉄球の生成
     **/
    public function addIron(id:Int, px:Int, py:Int):Void {
        var i:Iron = new Iron(id, px, py);
        _irons.add(i);
    }

    /**
     * 更新
     **/
    override public function update():Void {
        super.update();

        switch(_state) {
            case State.Init: _updateInit();
            case State.Main: _updateMain();
            case State.GameoverInit:
            _timer--;
            if(_timer < 1) {
                _state = State.GameoverMain;
                _displaySubMessage("Retry to press Z or Space key.");
            }

            case State.GameoverMain:
            if(_isPressDecide()) {
                FlxG.resetState();
            }

            case State.StageclearInit:
            _timer--;
            if(_timer < 1) {
                _state = State.StageclearMain;
                _displaySubMessage("Next to press Z or Space key.");
            }

            case State.StageclearMain:
            if(_isPressDecide()) {
                Reg.stage++;
                if(false) {
                    // TODO: 全ステージクリア判定
                }
                else {
                    // 次のステージを開始する
                    FlxG.resetState();
                }
            }
        }

        _updateText();

        //#if !FLX_NO_DEBUG
        _updateDebug();
        //#end
    }

    /**
     * 更新・初期化
     **/
    private function _updateInit():Void {

        _state = State.Main;
    }

    /**
     * 更新・メイン
     **/
    private function _updateMain():Void {

        // カベとの衝突判定
        if(_level.collideWithLevel(_player)) {
            // 衝突したので停止要求を送る
            _player.requestStop();
        }

        // アイテムとの衝突判定
        FlxG.overlap(_player, _items, _vsPlayerItem, _collideChip);

        // 敵との衝突判定
        FlxG.overlap(_player, _enemys, _vsPlayerEnemy, _collideChip);

        // 鉄球との衝突判定
        FlxG.overlap(_player, _irons, _vsPlayerIron, _collideChip);

        if(_player.exists == false) {
            // ゲームオーバーへ
            _state = State.GameoverInit;
            _timer = TIMER_GAMEOVER_INIT;

            _displayMessage("Game over!");
            return;
        }

        if(FlxG.overlap(_player, _goal, null, _collideChip)) {
            // ステージクリア
            _state = State.StageclearInit;
            _timer = TIMER_STAGECLEAR_INIT;

            _displayMessage("Stage clear!");
            _player.disabledInput(); // プレイヤーを止める
            return;
        }
    }
    /**
     * メッセージを表示する
     **/
    private function _displayMessage(message:String):Void {

        var h = 24;
        var rect:FlxSprite = new FlxSprite(0, FlxG.height/2 - h);
        rect.makeGraphic(FlxG.width, h*2, FlxColor.BLACK);
        rect.alpha = 0.5;
        add(rect);
        var text:FlxText = new FlxText(0, FlxG.height/2 - h/2-8, FlxG.width*2/3);
        text.alignment = "center";
        text.text = message;
        text.size = 16;
        add(text);
    }

    /**
     * サブメッセージを表示する
     **/
    private function _displaySubMessage(message:String):Void {

        var text:FlxText = new FlxText(0, FlxG.height/2 + 8, FlxG.width*2/3);
        text.alignment = "center";
        text.text = message;
        add(text);
        _txSubMessage = text;
    }

    /**
     * 座標が一致したら当たりにする当たり判定
     **/
    private function _collideChip(obj1:FlxObject, obj2:FlxObject):Bool {
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
        _emitterEnemy.explode(enemy.x+enemy.width/2, enemy.y+enemy.height/2);
    }

    /**
     * プレイヤーとアイテムとの衝突
     **/
    private function _vsPlayerItem(player:Player, item:Item):Void {

        var eft:EffectText = _effecttext.recycle();
        var px:Float = player.x;
        var py:Float = player.y;

        switch(item.getId()) {
            case Item.ID_BANANA:
                player.addHp(1); // HP回復
                eft.init(EffectTextMode.Recover, px, py, 1);

            case Item.ID_HEART:
                var v:Int = player.getHpMax() - player.getHp();
                player.addHp(v); // HPが最大まで回復
                eft.init(EffectTextMode.Recover, px, py, v);

            case Item.ID_POWER:
                player.levelUp(); // レベルアップ
                eft.init(EffectTextMode.LevelUp, px, py);
        }
        item.vanish();
    }

    /**
     * プレイヤーと鉄球との衝突
     **/
    private function _vsPlayerIron(player:Player, iron:Iron):Void {

        if(player.isLevelMin()) {
            // レベルが最低ならダメージ
            player.damage(999);
        }
        else {
            // Lv2以上ならレベルダウン
            player.levelDown(); // レベルダウン
            var eft:EffectText = _effecttext.recycle();
            var px:Float = player.x;
            var py:Float = player.y;
            eft.init(EffectTextMode.LevelDown, px, py);
        }

        // 鉄球消滅
        iron.kill();
        _emitterEnemy.explode(iron.x+iron.width/2, iron.y+iron.height/2);
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

        // レベルバー更新
        _barLv.setPercent(_player.getLvRatio()*100);
        // HPバー更新
        _barHp.setPercent(_player.getHpRatio()*100);
    }

    private function _updateDebug():Void {
        if(FlxG.keys.justPressed.ESCAPE) {
            throw "Terminate.";
        }

        if(FlxG.keys.justPressed.F) {
            _player.addHp(1);
        }
        else if(FlxG.keys.justPressed.D) {
            _player.damage(1);
        }

        if(FlxG.keys.justPressed.ONE) {
            Reg.stage++;
            _txStage.text = "Stage: " + Reg.stage;
        }
        if(FlxG.keys.justPressed.TWO) {
            Reg.stage--;
            _txStage.text = "Stage: " + Reg.stage;
        }
        if(FlxG.keys.justPressed.THREE) {
            _player.damage(999);
        }
    }

    private function _isPressDecide():Bool {
        return FlxG.keys.anyJustPressed(["Z", "SPACE"]);
    }
}

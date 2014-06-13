package ;

import haxe.web.Dispatch.MatchRule;
import flixel.util.FlxPoint;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * 状態
 **/
private enum State {
    Standby; // 待機状態
    Walk;    // 歩いている状態
    Miss;    // 失敗
}

/**
 * 向き
 **/
private enum Direction {
    None;  // なし
    Left;  // 左向き
    Up;    // 上向き
    Right; // 右向き
    Down;  // 下向き
}

/**
 * プレイヤー
 **/
class Player extends FlxSprite {

    // アニメーション定数
    private static inline var ANIM_STANDBY = "standby"; // 待機
    private static inline var ANIM_WALK = "walk"; // 歩く
    private static inline var ANIM_MISS = "miss"; // 敵にやられた

    private static inline var WALK_SPEED = 100; // 歩く速さ
    private static inline var TILE_SIZE = 16; // 1つあたりのタイルサイズ

    // タイマー
    private static inline var TIMER_DAMAGE = 30; // ダメージタイマー

    // 変数
    private var _state:State; // 状態
    private var _direction:Direction; // 向き
    private var _prevX:Float; // 移動前のX座標
    private var _prevY:Float; // 移動前のY座標
    private var _reqStop:Bool; // 停止リクエスト

    private var _hp:Int = 3; // 現在のHP
    private var _hpmax:Int = 3; // 最大HP
    private var _level:Int = 1; // 現在のレベル

    private var _tDamage:Int = 0; // ダメージタイマー

    /**
     * コンストラクタ
     * @param px X座標
     * @param py Y座標
     **/
    public function new(px:Float, py:Float) {
        super(px, py);
        setPrev(px, py);

        // 画像ファイルを読み込み
        loadGraphic("assets/images/miku.png", true);

        // アニメーションを登録
        animation.add(ANIM_STANDBY, [0, 0, 0, 0, 0, 2, 0, 0, 0, 2], 6);
        animation.add(ANIM_WALK, [0, 1], 9);
        animation.add(ANIM_MISS, [3]);

        // アニメーションを再生
        _state = State.Standby;
        animation.play(ANIM_STANDBY);

        // 向きを初期化
        _direction = Direction.Down;

        // 停止要求クリア
        _reqStop = false;

        // ダメージタイマー初期化
        _tDamage = 0;

        FlxG.watch.add(this, "x");
        FlxG.watch.add(this, "y");
    }

    // HP取得
    public function getHp():Int return _hp;
    // 最大HP取得
    public function getHpMax():Int return _hpmax;
    // HPの割合を取得
    public function getHpRatio():Float return 1.0 * _hp / _hpmax;
    // レベル取得
    public function getLevel():Int return _level;
    // HPを増やす
    public function addHp(v:Int):Void _hp = if(_hp + v > _hpmax) _hpmax else _hp + v;

    /**
     * ダメージ
     * @param v ダメージ量
     **/
    public function damage(v:Int):Void {

        _hp = if(_hp - v < 0) 0 else _hp - v;
        if(_hp <= 0) {
            // 死亡
            vanish();
        }

        _tDamage = TIMER_DAMAGE;
    }

    /**
     * HPを設定
     **/
    public function setHp(v:Int):Void {
        _hp = v;
        _hpmax = v;
    }

    /**
     * 消滅
     **/
    public function vanish():Void {
        kill();
    }

    /**
     * 移動前の座標を覚えておく
     **/
    public function setPrev(px:Float, py:Float) {
        _prevX = px;
        _prevY = py;
    }

    /**
     * 停止要求をする
     **/
    public function requestStop():Void {
        _reqStop = true;
    }

    /**
     * レベルアップする
     **/
    public function levelUp():Void {
        _level++;
        _hpmax++;
    }

    /**
     * 更新
     **/
    override function update():Void {

        if(_tDamage > 0) {
            visible = _tDamage%4 < 2;
            _tDamage--;
        }

        super.update();

        velocity.set(0, 0);
        switch(_state) {
            case State.Standby:
            // 待機状態
            _updateStandby();

            case State.Walk:
            // 歩き中
            _updateWalk();

            case State.Miss:
        }
    }
    /**
     * 更新・待機状態
     **/
    public function _updateStandby():Void {
        if(_isOnLeft()) {
            // 左向きに歩き始める
            _direction = Direction.Left;
            _state = State.Walk;
            flipX = true;
        }
        else if(_isOnUp()) {
            // 上向き
            _direction = Direction.Up;
            _state = State.Walk;
        }
        else if(_isOnRight()) {
            // 右向き
            _direction = Direction.Right;
            _state = State.Walk;
            flipX = false;
        }
        else if(_isOnDown()) {
            // 下向き
            _direction = Direction.Down;
            _state = State.Walk;
        }

        if(_state == State.Walk) {
            // 歩きアニメを再生
            animation.play(ANIM_WALK);
            // 停止要求クリア
            _reqStop = false;
            // 移動前の座標を覚えておく
            setPrev(x, y);
        }
        else {
            animation.play(ANIM_STANDBY);
        }

    }

    /**
     * 更新・歩く
     **/
    public function _updateWalk():Void {

        var bStop:Bool = _reqStop;

        switch(_direction) {
            case Direction.Left:
                velocity.x = -WALK_SPEED;
                if(x <= _prevX-TILE_SIZE) {
                    x = _prevX-TILE_SIZE;
                    if(_isOnLeft()) {
                        _prevX -= TILE_SIZE;
                    }
                    else {
                        // 停止する
                        bStop = true;
                    }
                }
            case Direction.Up:
                velocity.y = -WALK_SPEED;
                if(y <= _prevY-TILE_SIZE) {
                    y = _prevY-TILE_SIZE;
                    if(_isOnUp()) {
                        _prevY -= TILE_SIZE;
                    }
                    else {
                        // 停止する
                        bStop = true;
                    }
                }
            case Direction.Right:
                velocity.x = WALK_SPEED;
                if(x >= _prevX+TILE_SIZE) {
                    x = _prevX+TILE_SIZE;
                    if(_isOnRight()) {
                        _prevX += TILE_SIZE;
                    }
                    else {
                        // 停止する
                        bStop = true;
                    }
                }
            case Direction.Down:
                velocity.y = WALK_SPEED;
                if(y >= _prevY+TILE_SIZE) {
                    y = _prevY+TILE_SIZE;
                    if(_isOnDown()) {
                        _prevY += TILE_SIZE;
                    }
                    else {
                        // 停止する
                        bStop = true;
                    }
                }
            default:
                _state = State.Standby;
        }

        if(bStop) {
            velocity.set(0, 0);
            x = TILE_SIZE * Math.floor(x/TILE_SIZE);
            y = TILE_SIZE * Math.floor(y/TILE_SIZE);
            _state = State.Standby;
        }
    }


    //-------------------------------------------------------
    // キー入力関係
    private function _isOnLeft():Bool {
        return FlxG.keys.pressed.LEFT;
    }
    private function _isOnUp():Bool {
        return FlxG.keys.pressed.UP;
    }
    private function _isOnRight():Bool {
        return FlxG.keys.pressed.RIGHT;
    }
    private function _isOnDown():Bool {
        return FlxG.keys.pressed.DOWN;
    }

}

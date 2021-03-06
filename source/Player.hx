package ;

import flixel.text.FlxText;
import EffectText.EffectTextMode;
import flixel.group.FlxTypedGroup;
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

    // レベルの最大
    private static inline var LEVEL_MIN = 1;
    private static inline var LEVEL_MAX = 5;

    // アニメーション定数
    private static inline var ANIM_STANDBY = "standby"; // 待機
    private static inline var ANIM_WALK = "walk"; // 歩く
    private static inline var ANIM_MISS = "miss"; // 敵にやられた

    private static inline var WALK_SPEED = 100; // 歩く速さ
    private static inline var TILE_SIZE = 16; // 1つあたりのタイルサイズ

    // タイマー
    private static inline var TIMER_DAMAGE = 30; // ダメージタイマー

    public static var s_emiiter:EmitterPlayer = null;
    public static var s_text:FlxTypedGroup<EffectText> = null;

    // HP表示
    private var _txHp:FlxText; // HP表示

    // 変数
    private var _state:State; // 状態
    private var _direction:Direction; // 向き
    private var _prevX:Float; // 移動前のX座標
    private var _prevY:Float; // 移動前のY座標
    private var _reqStop:Bool; // 停止リクエスト

    private var _hp:Int = 3; // 現在のHP
    private var _hpmax:Int = 3; // 最大HP
    private var _level:Int = 1; // 現在のレベル
    private var _nKey:Int = 0;  // カギを持っている数

    private var _tDamage:Int = 0; // ダメージタイマー
    private var _bInput:Bool = true; // 入力を有効にするかどうか

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

        _txHp = new FlxText(-100, -100, TILE_SIZE*3);
        _txHp.borderStyle = FlxText.BORDER_OUTLINE_FAST;
        _txHp.alignment = "center";

        FlxG.watch.add(this, "x");
        FlxG.watch.add(this, "y");
    }

    public function getTextHp():FlxText { return _txHp; }
    // HP取得
    public function getHp():Int { return _hp; }
    // 最大HP取得
    public function getHpMax():Int { return _hpmax; }
    // HPの割合を取得
    public function getHpRatio():Float { return 1.0 * _hp / _hpmax; }
    // レベル取得
    public function getLevel():Int { return _level; }
    // レベルの割合を取得
    public function getLvRatio():Float { return 1.0 * _level / LEVEL_MAX; }
    // HPを増やす
    public function addHp(v:Int):Void { _hp = if(_hp + v > _hpmax) _hpmax else _hp + v; }
    // カギの数を取得
    public function getKey():Int { return _nKey; }
    // カギを増やす
    public function addKey(v:Int = 1):Void { _nKey += v; }
    // カギを減らす
    public function subKey(v:Int = 1):Void {
        _nKey -= v;
        if(_nKey < 0) {
            _nKey = 0;
        }
    }

    /**
     * ダメージ
     * @param v ダメージ量
     **/
    public function damage(v:Int):Void {
        var text:EffectText = s_text.recycle();
        text.init(EffectTextMode.Damage, x, y, v);

        _hp = if(_hp - v < 0) 0 else _hp - v;
        if(_hp <= 0) {
            // 死亡
            vanish();
            FlxG.camera.flash(0xffFFFFFF, 0.3);
            FlxG.camera.shake(0.02, 0.35);

        }
        else {
            FlxG.camera.shake(0.01+0.005*v, 0.1+0.03*v);
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
     * レベルを設定
     **/
    public function setLv(v:Int):Void {
        _level = v;
    }

    /**
     * 消滅
     **/
    public function vanish():Void {
        s_emiiter.explode(x+width/2, y+height/2);
        kill();
        _txHp.visible = false;
        s_emiiter = null;
        s_text = null;
        FlxG.sound.play("dead");
        FlxG.sound.play("damage");
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

    // レベルが最大
    public function isLevelMax():Bool { return _level >= LEVEL_MAX; }
    /**
     * レベルアップする
     **/
    public function levelUp():Void {
        if(isLevelMax()) {
            // レベルが最大なのでレベルアップできない
            return;
        }

        _level++;
        _hpmax++;
        _hp++;
    }

    // レベルが最低
    public function isLevelMin():Bool { return _level <= LEVEL_MIN; }
    /**
     * レベルダウンする
     **/
    public function levelDown():Void {
        if(isLevelMin()) {
            // レベルが最低なのでレベルダウンできない
            return;
        }

        _level--;
        _hpmax--;
        if(_hpmax < 1) {
            _hpmax = 1;
        }
        if(_hp > _hpmax) {
            _hp = _hpmax;
        }
    }

    /**
     * 入力を無効にする
     **/
    public function disabledInput():Void {
        _bInput = false;
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

        // HP更新
        if(_hp != _hpmax) {
            _txHp.x = x-TILE_SIZE;
            _txHp.y = y+TILE_SIZE/2;
            _txHp.text = _hp + "/" + _hpmax;
            _txHp.visible = true;
        }
        else {
            _txHp.visible = false;
        }
    }

    private function _getNextPosition(dir:Direction):FlxPoint {
        var p = FlxPoint.get();
        p.set(x, y);
        switch(dir) {
            case Direction.Left:  p.x -= TILE_SIZE;
            case Direction.Up:    p.y -= TILE_SIZE;
            case Direction.Right: p.x += TILE_SIZE;
            case Direction.Down:  p.y += TILE_SIZE;
            default:
        }

        return p;
    }

    /**
     * 指定の方向に移動できるかどうか
     * @param dir 方向
     * @return 移動できればtrue
     **/
    private function _canMove(dir:Direction):Bool {
        var p = _getNextPosition(_direction);

        if(getKey() > 0) {
            // カギがあればカギを使ってみる
            if(_getPlayState().useKey(p.x, p.y)) {
                // カギを使った
                subKey();
            }
        }

        if(_getPlayState().canMove(p.x, p.y)) {
            // 移動できる
            return true;
        }

        // 移動できない
        return false;
    }

    /**
     * 更新・待機状態
     **/
    public function _updateStandby():Void {

        if(_bInput == false) {
            // 動かせない
            return;
        }

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

            if(_canMove(_direction)) {
                // 移動できる
                // 移動前の座標を覚えておく
                setPrev(x, y);
            }
            else {
                // 移動できない
                _state = State.Standby;
            }
        }
        else {
            animation.play(ANIM_STANDBY);
        }

    }

    /**
     * 更新・歩く
     **/
    public function _updateWalk():Void {

        if(_bInput == false) {
            // 動かせない
            return;
        }

        var bStop:Bool = _reqStop;

        switch(_direction) {
            case Direction.Left:
                velocity.x = -WALK_SPEED;
                if(x <= _prevX-TILE_SIZE) {
                    x = _prevX-TILE_SIZE;
                    if(_isOnLeft() && _canMove(_direction)) {
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
                    if(_isOnUp() && _canMove(_direction)) {
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
                    if(_isOnRight() && _canMove(_direction)) {
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
                    if(_isOnDown() && _canMove(_direction)) {
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

    private function _getPlayState():PlayState {
        return cast FlxG.state;
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

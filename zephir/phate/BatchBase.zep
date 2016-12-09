namespace Phate;

abstract class BatchBase
{
    /**
     * 初期化メソッド
     */
    abstract public function initialize() -> void;

    /**
     * 実行メソッド
     */
    abstract public function execute() -> void;

    /**
     * お片付けメソッド
     */
    abstract public function finally() -> void;
}

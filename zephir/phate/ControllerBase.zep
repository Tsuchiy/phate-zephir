namespace Phate;

abstract class ControllerBase
{
    /**
     * 一番初めに呼ばれる、メソッド
     *
     * @return boolean falseを返すと、そこで処理が止まります。
     *
     * @abstract
     */
    abstract public function initialize();

    /**
     * 実処理
     *
     * @return   void
     * @see      validate()
     * @abstract
     */
    abstract public function action();

    /**
     * バリデートする
     *
     * @return   true|false boolean
     * @abstract
     */
    abstract public function validate();

    /**
     * 上のvalidate()でfalseが返った場合の処理。
     *
     * @param array resultArray validate result array
     *
     * @return   void
     * @see      validate()
     * @abstract
     */
    abstract public function validatorError(array resultArray);
}


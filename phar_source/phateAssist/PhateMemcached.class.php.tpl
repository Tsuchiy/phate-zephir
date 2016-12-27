
/**
 * PhateMemcachedクラスファイル
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 **/
namespace Phate;

/**
 * Memcachedクラス
 *
 * 設定ファイル読んで、Memcacheに接続したmemcachedのインスタンスを操作するクラス
 * 名前空間毎にprefixの処理なんかもする
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 * @create   2014/11/13
 **/
abstract class Memcached
{

    /**
     * Memcacheに値を格納
     * バックアップサーバ対策？のためにキーを全サーバに保存しに行く
     *
     * @param string  $key        key
     * @param mixed   $value      value
     * @param integer $expiration expiration
     * @param string  $namespace  connection namespace
     *
     * @return bool
     */
    abstract public static function set($key, $value, $expiration = null, $namespace = 'default');

    /**
     * Memcacheに値を複数格納
     * バックアップサーバ対策？のためにキーを全サーバに保存しに行く
     *
     * @param array   $items      [key=>value]
     * @param integer $expiration expiration
     * @param string  $namespace  connection namespace
     *
     * @return bool
     */
    abstract public static function setMulti(array $items, $expiration = null, $namespace = 'default');

    /**
     * Memcacheより値を取得
     *
     * @param string $key       key
     * @param string $namespace connection namespace
     *
     * @return mixed|bool
     */
    abstract public static function get($key, $namespace = 'default');

    /**
     * Memcacheより値を配列で取得
     *
     * @param string $keys      key array
     * @param string $namespace connection namespace
     *
     * @return array|bool
     */
    abstract public static function getMulti(array $keys, $namespace = 'default');

    /**
     * Memcacheより値を消去
     * バックアップ対策？のためにキーを全サーバに削除しに行く
     *
     * @param string $key       key
     * @param string $namespace connection namespace
     *
     * @return bool
     */
    abstract public static function delete($key, $namespace = 'default');

    /**
     * Memcacheより値を配列で消去
     * バックアップ対策？のためにキーを全サーバに削除しに行く
     *
     * @param array  $keys      key array
     * @param string $namespace connection namespace
     *
     * @return bool
     */
    abstract public static function deleteMulti(array $keys, $namespace = 'default');
    
    /**
     * Memcacheより全てのキー一覧を取得（ただし保証はされない）
     *
     * @param string $namespace connection namespace
     *
     * @return array
     */
    abstract public static function getAllKeys($namespace = 'default');

    /**
     * 直前のmemcached結果コードを取得
     * バックアップ対策？のために全サーバに更新処理をかけているので、
     * 必ずしも意図した値は保証されないかもしれない
     *
     * @param string $namespace connection namespace
     *
     * @return integer
     */
    abstract public static function getResultCode($namespace = 'default');

    /**
     * Memcache機能の無効化を行う
     * debug時用
     *
     * @param bool $disable
     *
     * @return void
     */
    abstract public static function setInvalid(bool $disable = true);

    /**
     * 名前空間にある全てのキーを削除する
     *
     * @param string $cacheNameSpace = "default"
     * @param int    $delay          = 0
     *
     * @return bool
     */
    abstract public static function flush(string $cacheNameSpace = "default", int $delay = 0);
}

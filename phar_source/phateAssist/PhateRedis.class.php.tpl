
/**
 * PhateRedisクラスファイル
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 **/
namespace Phate;

/**
 * Redisクラス
 *
 * 設定ファイルより接続済みRedisクラス取得クラス
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 * @create   2016/12/23
 **/
abstract class Redis
{
    /**
     * 設定ファイルよりredisの設定を取得
     *
     * @return void
     */
    abstract public static function setConfig();
    
    
    /**
     * 接続名のインスタンスを返す
     *
     * @param string $namespace 接続先名前空間
     *
     * @return \Redis
     */
    abstract public static function getInstance($namespace);
}

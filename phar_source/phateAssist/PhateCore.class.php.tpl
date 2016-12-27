
/**
 * PhateCoreクラス及び共通処理ファイル
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 **/
namespace Phate;

/**
 * Coreクラス
 *
 * Frameworkを実行する中心部分となります。
 * web経由での展開はdispatch、バッチの実行はdoBatchを用いてください。
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 * @create   2016/12/22
 **/
abstract class Core
{
    
    /**
     * Singleton取得
     *
     * @param string $appName       projectName
     * @param bool   $isDebug       is DebugMode?
     * @param string $serverEnv     environment
     * @param string $baseDirectory base directory
     *
     * @return Core
     */
    abstract public static function getInstance(
        string $appName = null,
        bool $isDebug = false,
        string $serverEnv = "local",
        string $baseDirectory = null
    );

    /**
     * ServerEnv取得
     *
     * @param void
     *
     * @return string
     */
    abstract public static function getServerEnv();

    /**
     * AppName取得
     *
     * @param void
     *
     * @return string
     */
    abstract public static function getAppName();

    /**
     * AppName取得
     *
     * @param void
     *
     * @return string
     */
    abstract public static function isDebug();

    /**
     * BaseDirectory取得
     *
     * @param void
     *
     * @return string
     */
    abstract public static function getBaseDir();

    /**
     * CacheDirectory取得
     *
     * @param void
     *
     * @return string
     */
    abstract public static function getCacheDir();

    /**
     * ConfigDirectory取得
     *
     * @param void
     *
     * @return string
     */
    abstract public static function getConfigDir();

    /**
     * ProjectDirectory取得
     *
     * @param void
     *
     * @return string
     */
    abstract public static function getProjectDir();

    /**
     * Version取得
     *
     * @param void
     *
     * @return string
     */
    abstract public static function getVersion();

    /**
     * Config値取得
     *
     * @param string|void $key
     * @param mixed       $defaultValue
     *
     * @return string
     */
    abstract public static function getConfigure(string $key = null, $defaultValue = null);

    /**
     * HTTPリクエスト展開実行
     *
     * @param void
     *
     * @return vopid
     */
    abstract public function dispatch();

    /**
     * バッチ実行
     *
     * @param string $className execute class name
     *
     * @return void
     */
    abstract public function doBatch(string $className);
}

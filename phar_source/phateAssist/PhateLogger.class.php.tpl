
/**
 * PhateLoggerクラスファイル
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 **/
namespace Phate;

/**
 * Loggerクラス
 *
 * Logに記録するクラス。記録レベルや対象ファイルは設定ファイルにて設定されます。
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 * @create   2016/12/23
 **/
abstract class Logger
{
    /**
     * Debugレベルログ出力
     *
     * @param string $string writing string
     *
     * @return void
     */
    abstract public static function debug($string);

    /**
     * Infoレベルログ出力
     *
     * @param string $string writing string
     *
     * @return void
     */
    abstract public static function info($string);

    /**
     * Warningレベルログ出力
     *
     * @param string $string writing string
     *
     * @return void
     */
    abstract public static function warning($string);
    
    /**
     * Errorレベルログ出力
     *
     * @param string $string writing string
     *
     * @return void
     */
    abstract public static function error($string);

    /**
     * Criticalレベルログ出力
     *
     * @param string $string writing string
     *
     * @return void
     */
    abstract public static function critical($string);
}

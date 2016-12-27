
/**
 * PhateResponseクラスファイル
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 **/
namespace Phate;

/**
 * ThrownExceptionBaseクラス
 *
 * Exceptionが投げられた際ののプロジェクト別処理用クラスの継承元クラス
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 * @create   2016/12/23
 **/
abstract class ExceptionHandlerBase
{
    /**
     * 実処理
     *
     * @param Exception $e 例外
     *
     * @return void
     *
     * @abstract
     */
    abstract public function handler(\Exception $e);
}

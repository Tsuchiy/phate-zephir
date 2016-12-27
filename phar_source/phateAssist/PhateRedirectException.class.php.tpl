
/**
 * Phate例外クラスファイル
 *
 * @category Framework
 * @package  BaseExceptions
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 **/
namespace Phate;

/**
 * RedirectException例外
 *
 * 他のURLへリダイレクトをする際にthrowする例外。
 * 標準出力は全て破棄されます。
 *
 * @category Framework
 * @package  BaseExceptions
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 * @create   2014/11/13
 **/
class RedirectException extends Exception
{
}

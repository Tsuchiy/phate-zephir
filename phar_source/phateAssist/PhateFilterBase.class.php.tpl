
/**
 * PhateFilterBaseクラスファイル
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 **/
namespace Phate;

/**
 *  PhateFilterBaseクラス
 *
 *  Filterを作る際の継承元クラス
 *
 * @category Framework
 * @package  BaseLibrary
 * @abstract
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @create   2016/12/23
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 **/
abstract class FilterBase
{

    /**
     * フィルタの実行
     *
     * @return void
     */
    abstract public function execute();
}

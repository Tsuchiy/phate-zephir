
namespace Phate;

/**
 * PureRendererクラス
 *
 * パラメータをダンプ出力するレンダラ
 *
 * @package PhateFramework
 * @access  public
 * @author  Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @create  2016/12/23
 **/
abstract class PureRenderer
{
    
    /**
     * 描画
     *
     * @param mixed $value 描画内容
     */
    abstract public function render($value);
}

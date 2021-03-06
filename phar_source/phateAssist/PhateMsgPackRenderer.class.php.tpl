
namespace Phate;

/**
 * MsgPackRendererクラス
 *
 * MsgPackでシリアライズしたバイナリの出力を行うレンダラ
 *
 * @package PhateFramework
 * @access  public
 * @author  Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @create  2016/12/23
 **/
class MsgPackRenderer
{
    /**
     * 描画
     *
     * @param mixed $value
     *
     * @return void
     */
    public function render($value);
}

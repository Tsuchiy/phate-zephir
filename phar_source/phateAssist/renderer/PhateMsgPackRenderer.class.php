<?php
namespace Phate;

/**
 * MsgPackRendererクラス
 *
 * MsgPackでシリアライズしたバイナリの出力を行うレンダラ
 *
 * @package PhateFramework
 * @access  public
 * @author  Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @create  2014/11/13
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

<?php
namespace Phate;

/**
 * PureRendererクラス
 *
 * パラメータをダンプ出力するレンダラ
 *
 * @package PhateFramework
 * @access  public
 * @author  Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @create  2014/11/13
 **/
interface PureRenderer
{
    
    /**
     * 描画
     *
     * @param mixed $value 描画内容
     */
    public function render($value);
}

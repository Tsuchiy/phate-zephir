<?php
namespace Phate;

/**
 * JsonRendererクラス
 *
 * json_encodeしたtextの出力を行うレンダラ
 *
 * @package PhateFramework
 * @access  public
 * @author  Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @create  2014/11/13
 **/
interface JsonRenderer
{
    /**
     * 描画
     *
     * @param array $value
     *
     * @return void
     */
    public function render(array $value);
}

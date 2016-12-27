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
 * @create  2016/12/23
 **/
abstract class JsonRenderer
{
    /**
     * 描画
     *
     * @param array $value
     *
     * @return void
     */
    abstract public function render(array $value);
}

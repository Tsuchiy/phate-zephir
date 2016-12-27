<?php
namespace Phate;

/**
 * CsvRendererクラス
 *
 * csvとして出力するレンダラ
 *
 * @package PhateFramework
 * @access  public
 * @author  Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @create  2016/12/23
 **/
abstract class CsvRenderer
{
    /**
     * カラム名一覧の設定
     *
     * @param array $columnNameArray カラム名一覧
     *
     * @return void
     */
    abstract public function setColumnNames(array $columnNameArray);
    
    /**
     * 描画
     *
     * @param array  $listArray 出力データ
     * @param string $filename  ファイル名
     *
     * @return void
     */
    abstract public function render(array $listArray, string $filename = "");
}

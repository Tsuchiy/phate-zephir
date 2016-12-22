<?php
namespace Phate;

/**
 * PhpRendererクラス
 *
 * phpコードをパラメータを適用してeval出力するレンダラ
 *
 * @package PhateFramework
 * @access  public
 * @author  Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @create  2016/12/22
 **/
interface PhpRenderer
{

    /**
     * コンストラクタ
     *
     * @param string $basePath base (absolute) path of templates
     */
    public function __construct(string $basePath);

    /**
     * 描画しないで結果のみ取る
     *
     * @param string $targetFileName 描画ファイル
     * @param array $parameters 適用変数([valiable name => value])
     */
    public function execute(string $targetFileName, array $parameters = []);

    /**
     * 描画
     *
     * @param string $targetFileName 描画ファイル
     * @param array $parameters 適用変数([valiable name => value])
     */
    public function render(string $targetFileName, array $parameters = []);

    /**
     * ファイルのキャッシュ使用設定
     *
     * @param bool $isUsingCache キャッシュを使うか(defaultは!Core::isDebug())
     */
    public function setUsingCache($isUsingCache);

    /**
     * ファイルのキャッシュ破棄
     *
     * @param string $targetFileName 対応ファイル
     */
    public function unloadCache(string $targetFileName);
}

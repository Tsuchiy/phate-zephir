<?php
/**
 * PhateFluentdクラスファイル
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 **/
namespace Phate;

/**
 * Fluentdクラス
 *
 * Fluentdにポストするクラス。記録レベルや対象ソケットはログ設定ファイルにて設定されます。
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 * @create   2016/12/23
 **/
class Fluentd
{
    /**
     * Fluentロガーに出力
     *
     * @param string $targetName post target
     * @param string $tag        tag
     * @param array  $data       data
     *
     * @return void
     */
    public static function post(string $targetName, string $tag, array $data);
}

<?php
/**
 * PhateCommonクラスファイル
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 **/
namespace Phate;

/**
 * Commonクラス
 *
 * 基礎的な（フレームワークが動作するのに必要な）共通関数を配置するのに使っています。
 * 詳細な機能の共通関数はまた新しいクラスを用意します。
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 * @create   2016/12/22
 **/
class Common
{
    const CONTEXT_ROOT_REPLACE = '%%CONTEXT_ROOT%%';

    /**
     * サーバ環境に合わせたyamlの読み込みと配列化 with キャッシュ
     *
     * @param string $filename yaml filename
     *
     * @return array
     */
    public static function parseConfigYaml($filename);
    
    /**
     * ファイル名と中身からネームスペース付きでクラス名を取得する
     *
     * @param string $fileName
     *
     * @return string
     */
    public static function getClassNameWithNamespace(string $fileName);
    
    /**
     * 特定のパスから配下のファイル名を再帰的に取得
     *
     * @param string $path target path
     *
     * @return array
     */
    public static function getFileNameRecursive(string $path);
    
    /**
     * Snake_case等の文字列をPascalCaseに置換する
     *
     * @param string $string snake case string
     *
     * @return string pascal case string
     */
    public static function pascalizeString($string);

    /**
     * Snake_case等の文字列をcamelCaseに置換する
     *
     * @param string $string snake case string
     *
     * @return string camel case string
     */
    public static function camelizeString($string);

    /**
     * PascalCase等の文字列をsnake_caseに置換する
     *
     * @param string $string pascal case string
     *
     * @return string snake case string
     */
    public static function toSnakeCaseString($string);

    /**
     * アルゴリズムに優先を付けてシリアライズする
     *
     * @param mixed $mixed any object
     *
     * @return string
     */
    public static function serialize($mixed);
    
    /**
     * アルゴリズムに優先を付けてアンシリアライズする
     *
     * @param string $string serialized bytes
     *
     * @return mixed
     */
    public static function unserialize($string);
}

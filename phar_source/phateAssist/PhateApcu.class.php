<?php
/**
 * PhateApcuクラスファイル
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 **/
namespace Phate;

/**
 * Apcuクラス
 *
 * 設定ファイル読んで、Apcuのストアを操作するクラス
 * 名前空間毎にprefixの処理なんかもする
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 * @create   2014/11/13
 **/
abstract class Apcu
{
    /**
     * Apcuより値を取得
     *
     * @param string $key
     * @param mixed $value
     * @param int $ttl
     * @param string $cacheNameSpace
     *
     * @return bool;
     */
    abstract public static function set(string $key, $value, int $ttl = null, string $cacheNameSpace = "default");

    /**
     * Apcuより値を取得
     *
     * @param string $key
     * @param string $cacheNameSpace
     *
     * @return mixed
     */
    abstract public static function get(string $key, string $cacheNameSpace = "default");

    /**
     * Apcuより値を消去
     *
     * @param string $key
     * @param string $cacheNameSpace
     *
     * @return bool
     */
    abstract public static function delete(string $key, string $cacheNameSpace = "default");

    /**
     * Apcuより全てのキー一覧を取得（ただし保証はされない）
     *
     * @param string $cacheNameSpace
     *
     * @return array
     */
    abstract public static function getAllKeys(string $cacheNameSpace = null);
    
    /**
     * Apcu機能の無効化を行う
     * debug時用
     *
     * @param bool $isInvalid
     *
     * @return array
     */
    abstract public static function setInvalid(bool $isInvalid = true);
}
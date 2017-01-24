<?php
/**
 * PhateHttpRequestクラスファイル
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 **/
namespace Phate;

/**
 * HttpRequestクラス
 *
 * Httpリクエストで取得できる値を格納しておくクラス
 * コード内部から直接グローバル変数へアクセスすることを防ぐ
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 * @create   2014/11/13
 **/
class Request
{
    /**
     * HTTPリクエスト情報オブジェクトを取得する
     *
     * @return Request
     *
     * @throws NotFoundException
     **/
    
    
    public static function getInstance();

    /**
     * リクエストメソッドを取得する
     *
     * @return string
     */
    public static function getMethod();

    /**
     * サーバーパラメータ($_SERVER)を取得する
     *
     * @param string $key     (null時は全配列)
     * @param mixed  $default
     *
     * @return mixed|array
     */
    public static function getServerParam(string $key = null, $defaultValue = null);

    /**
     * リクエストパラメータ(GET/POST)を取得する
     *
     * @param string $key          (null時は全配列)
     * @param mixed  $defaultValue
     *
     * @return mixed|array
     */
    public static function getRequestParam(string $key = null, $defaultValue = null);

    /**
     * リクエストパラメータ(GET/POST)を設定する
     *
     * @param string $key
     * @param mixed  $defaultValue
     *
     * @return void
     */
    public static function setRequestParam(string $key, $defaultValue);

    /**
     * リクエストパラメータを初期化する
     *
     * @return void
     */
    public static function resetRequestParam();

    /**
     * GETパラメータを取得する
     *
     * @param string $key          null時は全配列
     * @param mixed  $defaultValue
     *
     * @return mixed
     */
    public static function getGetParam(string $key = null, $defaultValue = null);

    /**
     * POSTパラメータを取得する
     *
     * @param string $key          null時は全配列
     * @param mixed  $defaultValue
     *
     * @return mixed
     */
    public static function getPostParam(string $key = null, $defaultValue = null);

    /**
     * 生のPOSTデータを取得する
     *
     * @return string
     */
    public static function getRawPostData();

    /**
     * リクエストヘッダパラメータを取得する
     *
     * @param string $key          null時は全配列
     * @param string $defaultValue
     *
     * @return mixed
     */
    public static function getHeaderParam(string $key = null, $defaultValue = null);


    /**
     * リクエスト時にコールされたModule名を取得する
     *
     * @return string
     */
    public static function getCalledModule();
    
    /**
     * リクエスト時にコールされたController名を取得する
     *
     * @return string
     */
    public static function getCalledController();


    /**
     * nginxでもgetallheadersを使うために拡張
     *
     * @retrun array
     */
    public static function getallheaders();
}

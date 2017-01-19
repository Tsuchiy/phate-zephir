
/**
 * PhateResponseクラスファイル
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 **/
namespace Phate;

/**
 * Responseクラス
 *
 * Httpレスポンスを行う際、必要な処理を格納しておくクラス
 * 主にはレスポンスヘッダ・HTTPステータスの設定
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 * @create   2016/12/23
 **/
class Response
{
    const HTTP_OK = 200;
    const HTTP_UNAUTHORIZED = 401;
    const HTTP_NOT_FOUND = 404;
    const HTTP_INTERNAL_SERVER_ERROR = 500;
    const HTTP_SERVICE_UNAVAILABLE = 503;

    /**
     * インスタンスを取得する
     *
     * @return Response
     **/
    public static function getInstance();

    /**
     * セットされたレスポンスのヘッダを送信する
     *
     * @return void
     **/
    public function sendHeader();

    /**
     * レスポンスのbodyを取得
     *
     * @return string
     **/
    public static function getContentBody();

    /**
     * レスポンスのbodyをセット
     *
     * @param string $contentString
     *
     * @return void
     **/
    public static function setContentBody(string $contentString);

    /**
     * レスポンス時に返すHTTPStatusをセットする
     *
     * @param int statusCode HTTPステータスコード
     *
     * @return void
     **/
    public static function setHttpStatus(int $statusCode);

    /**
     * ロジックエラーコードを取得する
     *
     * @return string
     **/
    public static function getLogicalErrorCode();
    
    /**
     * ロジックエラーコードを設定する
     *
     * @param string $statusCode
     *
     * @return void
     **/
    public static function setLogicalErrorCode(string $statusCode);

    /**
     * Content-Typeヘッダの設定
     *
     * @param string $contentType content-type
     *
     * @return void
     **/
    public static function setContentType(string $contentType);

    /**
     * リダイレクトヘッダの設定(設定されているとリダイレクトが優先される)
     *
     * @param string $url
     *
     * @return void
     **/
    public static function setRedirectUrl(string $url);

    /**
     * レスポンス時のHTTPヘッダの設定
     *
     * @param string $key
     * @param string $value
     *
     * @return void
     **/
    public static function setHeader(string $key, string $value);

    /**
     * 現在のHTTPヘッダ情報を取得
     *
     * @return array
     **/
    public static function getReponseInfo();
}

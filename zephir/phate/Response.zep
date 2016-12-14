namespace Phate;

class Response
{
    const HTTP_OK = 200;
    const HTTP_UNAUTHORIZED = 401;
    const HTTP_NOT_FOUND = 404;
    const HTTP_INTERNAL_SERVER_ERROR = 500;
    const HTTP_SERVICE_UNAVAILABLE = 503;
    
    private static instance = null;

    private httpStatus;
    private contentType;
    private redirectUrl;
    private logicalErrorCode;
    private headerParam;

    private contentBody;

    public static function getInstance()
    {
        if (is_null(self::instance)) {
            let self::instance = new Response();
        }
        return self::instance;
    }

    private function __construct() 
    {
        let this->httpStatus = self::HTTP_OK;
        let this->contentType = "";
        let this->redirectUrl = "";
        let this->logicalErrorCode = 0;
        let this->headerParam = [];
        let this->contentBody = "";
    }
    
    /**
     * レスポンスのヘッダを送信する
     *
     * @return void
     *
     * @throws KillException
     **/
    public function sendHeader()
    {
        // リダイレクト設定がある場合はリダイレクトして終了
        if (this->redirectUrl !== "") {
            header("Location: " . this->redirectUrl);
            throw new KillException();
        }
        // ヘッダ処理
        header("Error-Code: " . this->logicalErrorCode);
        var key;
        var value;
        for key,value in this->headerParam {
            header(key . ": " . value);
        }
        // それ以外のレスポンス
        http_response_code(this->httpStatus);
        if (this->httpStatus != self::HTTP_OK) {
            return;
        }
        if (this->contentType !== "") {
            header("Content-Type: " . this->contentType);
        }
        return;
    }

    /**
     * レスポンスのbody
     **/
    public static function getContentBody()
    {
        return self::instance->contentBody;
    }

    private function setContentBodyInstance(string contentString)
    {
        let this->contentBody = contentString;
    }
    public static function setContentBody(string contentString)
    {
        self::instance->setContentBodyInstance(contentString);
    }
    /**
     * レスポンス時に返すHTTPStatusをセットする
     *
     * @param int statusCode HTTPステータスコード
     *
     * @return void
     **/
    private function setHttpStatusInstance(int statusCode)
    {
        let this->httpStatus = statusCode;
    }
    public static function setHttpStatus(int statusCode)
    {
        self::instance->setHttpStatusInstance(statusCode);
    }
    /**
     * ロジックエラーコード
     *
     **/
    public static function getLogicalErrorCode()
    {
        return self::instance->logicalErrorCode;
    }
    private function setLogicalErrorCodeInstance(string statusCode)
    {
        let this->logicalErrorCode = statusCode;
    }
    
    public static function setLogicalErrorCode(string statusCode)
    {
        self::instance->setLogicalErrorCodeInstance(statusCode);
    }
    /**
     * Content-Typeヘッダの設定
     *
     * @param string $contentType content-type
     *
     * @return void
     **/
    private function setContentTypeInstance(string contentType)
    {
        let this->contentType = contentType;
    }
    public static function setContentType(string contentType)
    {
        self::instance->setContentTypeInstance(contentType);
    }

    /**
     * リダイレクトヘッダの設定(設定されているとリダイレクトが優先される)
     *
     * @param string $url 遷移先URL
     *
     * @return void
     **/
    private function setRedirectUrlInstance(string url)
    {
        let this->redirectUrl = url;
    }
    public static function setRedirectUrl(string url)
    {
        self::instance->setRedirectUrlInstance(url);
    }

    /**
     * レスポンス時のHTTPヘッダの設定
     *
     * @param string $key   項目名
     * @param string $value 値
     *
     * @return void
     **/
    private function setHeaderInstance(string key, string value)
    {
        let this->headerParam[key] = value;
    }
    public static function setHeader(string key, string value)
    {
        self::instance->setHeaderInstance(key, value);
    }

    /**
     * HTTPヘッダ情報を取得
     *
     * @return array
     **/
    public static function getReponseInfo()
    {
        return [
            "http_status"        : self::instance->httpStatus,
            "content_type"       : self::instance->contentType,
            "redirect_url"       : self::instance->redirectUrl,
            "logical_error_code" : self::instance->logicalErrorCode,
            "header_param"       : self::instance->headerParam
            ];
    }
}


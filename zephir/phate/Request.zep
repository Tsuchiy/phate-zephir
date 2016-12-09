namespace Phate;

class Request
{
    private static instance;

    private serverParam;
    private requestParam;
    private getParam;
    private postParam;
    private rawPostData;
    private queryParam;
    
    private headerParam;

    private method;
    
    private calledModuleName;
    private calledControllerName;


    public static function getInstance() -> <Request>
    {
        if (is_null(self::instance)) {
            let self::instance = new Request();
            self::instance->init();
        }
        return self::instance;
    }

    private function __construct()
    {
        // スーパーグローバルの退避
        let this->serverParam = _SERVER;
        let this->requestParam = _REQUEST ? _REQUEST : [];
        let this->getParam = _GET ? _GET : [];
        let this->rawPostData = file_get_contents("php://input");
        let this->postParam = _POST ? _POST : [];
        let this->queryParam = [];
    }
        
    private function init() -> void
    {
        // リクエストメソッド
        let this->method = array_key_exists("REQUEST_METHOD", this->serverParam) ? this->serverParam["REQUEST_METHOD"] : "GET";
        // クライアントからのヘッダ情報
        let this->headerParam = this->getallheaders();
        // request_uri処理
        var tmpArray;
        var value;
        if (array_key_exists("REQUEST_URI", this->serverParam)) {
            let tmpArray = explode("/", this->serverParam["REQUEST_URI"]);
            for value in tmpArray {
                if (strlen(trim(value)) > 0) {
                    let this->queryParam[] = trim(value);
                }
            }
        }

        // コントローラ情報
        let this->calledModuleName = count(this->queryParam) >= 1 ? this->queryParam[0] : "index";
        let this->calledControllerName = count(this->queryParam) >= 2 ? this->queryParam[1] : "Index";
    }

    /**
     * リクエストメソッドを取得する
     * 
     * @access public
     * @param void
     * @return string
     */
    public static function getMethod() -> string
    {
        return self::instance->method;
    }

    /**
     * サーバーパラメータ($_SERVER)を取得する
     * 
     * @access public
     * @param string $key (null時は全配列)
     * @param string $default
     * @return mixed|array
     */
    public static function getServerParam(string key = null, var defaultValue = null)
    {
        var tmpArray;
        let tmpArray = self::instance->serverParam;
        if (key === "") {
            return tmpArray;
        } else {
            return array_key_exists(key, tmpArray) ? tmpArray[key] : defaultValue;
        }
    }

    /**
     * リクエストパラメータ(GET/POST)を取得する
     * 
     * @access public
     * @param string $key (null時は全配列)
     * @param string $default
     * @return mixed|array
     */
    public static function getRequestParam(string key = null, var defaultValue = null)
    {
        var tmpArray;
        let tmpArray = self::instance->requestParam;
        if (key === "") {
            return tmpArray;
        } else {
            return array_key_exists(key, tmpArray) ? tmpArray[key] : defaultValue;
        }
    }

    /**
     * リクエストパラメータ(GET/POST)を設定する
     * 
     * @access public
     * @param string $key
     * @param mixed $value
     * @return void
     */
    private function setRequestParamInstance(string key, var value)
    {
        let this->requestParam[key] = value;
    }
    public static function setRequestParam(string key, var value)
    {
        self::instance->setRequestParamInstance(key, value);
    }

    /**
     * GETパラメータを取得する
     * 
     * @access public
     * @param string $key (null時は全配列)
     * @return string|array
     */
    public static function getGetParam(string key = null, var defaultValue = null)
    {
        var tmpArray;
        let tmpArray = self::instance->getParam;
        if (key === "") {
            return tmpArray;
        } else {
            return array_key_exists(key, tmpArray) ? tmpArray[key] : defaultValue;
        }
    }

    /**
     * POSTパラメータを取得する
     * 
     * @access public
     * @param string $key (null時は全配列)
     * @return string|array
     */
    public static function getPostParam(string key = null, var defaultValue = null)
    {
        var tmpArray;
        let tmpArray = self::instance->postParam;
        if (key === "") {
            return tmpArray;
        } else {
            return array_key_exists(key, tmpArray) ? tmpArray[key] : defaultValue;
        }
    }

    /**
     * 生のPOSTデータを取得する
     * 
     * @access public
     * @param void
     * @return string
     */
    public static function getRawPostData()
    {
        return self::instance->rawPostData;
    }

    /**
     * リクエストヘッダパラメータを取得する
     * 
     * @access public
     * @param string $key/null時は全配列
     * @param string $default
     * @return mixed
     */
    public static function getHeaderParam(string key = null, var defaultValue = null)
    {
        var tmpArray;
        let tmpArray = self::instance->headerParam;
        if (key === "") {
            return tmpArray;
        } else {
            return array_key_exists(key, tmpArray) ? tmpArray[key] : defaultValue;
        }
    }

    /**
     * リクエスト時にコールされたModule名を取得する
     * 
     * @access public
     * @param void
     * @return string
     */
    public static function getCalledModule()
    {
        return self::instance->calledModuleName;
    }
    
    /**
     * リクエスト時にコールされたController名を取得する
     * 
     * @access public
     * @param void
     * @return string
     */
    public static function getController()
    {
        return self::instance->calledControllerName . "Controller";
    }

    /**
     * nginxでもgetallheadersを使うために拡張
     */
    public static function getallheaders()
    {
        if (function_exists("getallheaders")) {
            return getallheaders();
        }
        // nginx 用
        var headers;
        var name;
        var key;
        var value;
        let headers = []; 
        for key, value in self::instance->serverParam {
            if (substr(key, 0, 5) == "HTTP_") {
                let name = str_replace(" ", "-", ucwords(strtolower(str_replace("_", " ", substr(key, 5)))));
                let headers[name] = value;
            }
        }
        return headers;
    }
}

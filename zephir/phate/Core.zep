namespace Phate;

class Core
{

    const PHATE_VERSION = "0.0.1dev";

    private static instance = null;

    private appName;
    private serverEnv;
    private isDebug;
    private baseDirectory;

    private cacheDirectory;
    private configDirectory;
    private projectDirectory;

    private conf = null;
    private includeClassList = null;

    /**
     * Singleton取得
     */
    public static function getInstance(string appName=null, bool isDebug=false, string serverEnv="local", string baseDirectory=null) -> <Core>
    {
        
        if (is_null(self::instance)) {
            if (appName === "") {
                throw new Exception("no appName");
            }
            let self::instance = new Core(appName, isDebug, serverEnv, baseDirectory);
            self::instance->loadConfig();
            // 実行時間の初期化
            Timer::init();
            // ロガーを初期化
            Logger::init();
            // エラーハンドルにロガーをセット
            set_error_handler(["\\Phate\\Logger", "fatal"]);
            // autoloaderの設定
            spl_autoload_register("\\Phate\\Core::classLoader");
        }
        return self::instance;
    }
    

    /**
     * コンストラクタ
     */
    private function __construct(string appName, bool isDebug, string serverEnv, string baseDirectory)
    {
        let this->appName = appName;
        let this->isDebug = isDebug;
        let this->serverEnv = serverEnv;
        let this->baseDirectory = baseDirectory;
        let this->cacheDirectory = baseDirectory . "cache/";;
        let this->configDirectory = baseDirectory . "configs/";
        let this->projectDirectory = baseDirectory . "projects/" . appName . "/";
    }

    public static function getServerEnv() -> string
    {
        if (is_null(self::instance)) {
            throw new Exception("not initialized by Application");
        }
        return self::instance->serverEnv;
    }

    public static function getAppName() -> string
    {
        if (is_null(self::instance)) {
            throw new Exception("not initialized by Application");
        }
        return self::instance->appName;
    }

    public static function isDebug() -> bool
    {
        if (is_null(self::instance)) {
            throw new Exception("not initialized by Application");
        }
        return self::instance->isDebug;
    }

    public static function getBaseDir() -> string
    {
        if (is_null(self::instance)) {
            throw new Exception("not initialized by Application");
        }
        return self::instance->baseDirectory;
    }

    public static function getCacheDir() -> string
    {
        if (is_null(self::instance)) {
            throw new Exception("not initialized by Application");
        }
        return self::instance->cacheDirectory;
    }

    public static function getConfigDir() -> string
    {
        if (is_null(self::instance)) {
            throw new Exception("not initialized by Application");
        }
        return self::instance->configDirectory;
    }

    public static function getProjectDir() -> string
    {
        if (is_null(self::instance)) {
            throw new Exception("not initialized by Application");
        }
        return self::instance->projectDirectory;
    }

    public static function getVersion() -> string
    {
        return self::PHATE_VERSION;
    }

    /**
     * メイン設定読み込み
     */
    private function loadConfig() -> void
    {
        var configFileName;
        let configFileName = this->baseDirectory . "configs/" . this->appName . ".yml";
        let this->conf =  Common::parseConfigYaml(configFileName);
    }

    /**
     * メイン設定内項目取得
     */
    public static function getConfigure(string key = null, var defaultValue = null)
    {
        if (is_null(self::instance)) {
            throw new Exception("not initialized by Application");
        }
        var configArray;
        let configArray = self::instance->conf;
        if (key === "") {
            return configArray;
        }
        if (array_key_exists(key, configArray)) {
            return configArray[key];
        } else {
            return defaultValue;
        }
    }

    /**
     * オートローダ用メソッド
     */
    public static function classLoader(string className) -> void
    {
        if (is_null(self::instance)) {
            throw new Exception("not initialized by Application");
        }
        var classList;
        let classList = self::instance->getIncludeClassList();
        if (substr(className, 0, 1) !== "\\") {
            let className = "\\" . className;
        }
        if (array_key_exists(className, classList)) {
            require classList[className];
            return;
        }
    }

    /**
     * オートロード対象リスト取得
     */
    private function getIncludeClassList() -> array
    {
        if (is_null(this->includeClassList)) {
            // キャッシュ確認
            var rtn;
            var apcuCacheName;
            let apcuCacheName = "PhateAutoloadCache:" . this->appName . "_autoload_" . this->serverEnv . ".cache";
            if (function_exists("apcu_fetch") && !Core::isDebug()) {
                let rtn = Common::unserialize(apcu_fetch(apcuCacheName));
                if (rtn) {
                    return rtn;
                }
            }
            var cacheFileName;
            let cacheFileName = this->baseDirectory . "cache/" . this->appName . "_autoload_" . this->serverEnv . ".cache";
            if (file_exists(cacheFileName) && !Core::isDebug()) {
                let rtn = Common::unserialize(file_get_contents(cacheFileName));
                if (rtn) {
                    if (function_exists("apcu_fetch")) {
                        apcu_store(apcuCacheName, Common::serialize(rtn), 0);
                    }
                    return rtn;
                }
            }
            // オートロードロジック展開
            // 対象ディレクトリ
            var dirArray;
            let rtn = [];
            if (array_key_exists("autoload", this->conf) && is_array(this->conf["autoload"])) {
                let dirArray = this->conf["autoload"];
            } else {
                let dirArray = [];
            }
            // ディレクトリ展開
            var directoryName;
            var fileNames;
            var fileName;
            let fileNames = [];
            for directoryName in dirArray {
                if (file_exists(directoryName)) {
                    let fileNames = array_merge(fileNames, Common::getFileNameRecursive(directoryName));
                }
            }
            for fileName in fileNames {
                if (!preg_match("/^.*\.class\.php$/", fileName)) {
                    continue;
                }
                var className;
                let className = Common::getClassNameWithNamespace(fileName);
                let rtn[className] = fileName;
            }
            // キャッシュ保存
            var serializedData;
            let serializedData = Common::serialize(rtn);
            file_put_contents(cacheFileName, serializedData, LOCK_EX);
            if (substr(sprintf("%o", fileperms(cacheFileName)), -4) !==  "07" . "77") {
                chmod(cacheFileName, 0777);
            }
            if (function_exists("apcu_fetch")) {
                apcu_store(apcuCacheName, serializedData, 0);
            }
            let this->includeClassList = rtn;
        }
        return this->includeClassList;
    }

    /**
     * filter設定取得
     */
    private function getFilterConfig(var calledModule) -> array
    {
        var rtn;
        var filterConfig;
        let rtn = [
            "before" : [],
            "after"  : []
        ];
        if (array_key_exists("filter_config_file", this->conf)) {
            var key;
            var value;
            var tmpArray;
            let filterConfig = Common::parseConfigYaml(this->configDirectory . this->conf["filter_config_file"]);
            var phase;
            for phase in ["before", "after"] {
                if (array_key_exists(phase, filterConfig) && is_array(filterConfig[phase])) {
                    for key, value in filterConfig[phase] {
                        if (is_array(value) && array_key_exists("exclude", value)) {
                            let tmpArray = explode(",", value["exclude"]);
                            if (in_array(calledModule, tmpArray)) {
                                continue;
                            }
                        }
                        let rtn[phase][] = key;
                    }
                }
            }
        }
        return rtn;
    }

    /**
     * HTTPリクエスト展開実行
     */
    public function dispatch() -> void
    {
        var requestObj;
        var responseObj;

        // httpリクエスト/レスポンスの初期化・整理
        let requestObj = Request::getInstance();
        let responseObj = Response::getInstance();

        // load filter config
        var beforeFilters;
        var afterFilters;
        var filters;
        let filters = this->getFilterConfig(Request::getCalledModule());
        let beforeFilters = filters["before"];
        let afterFilters = filters["after"];

        // 対象の存在確認
        var controllerFile;
        if (!file_exists(this->projectDirectory . "controllers/CommonController.class.php")) {
            throw new Exception("CommonController file not found");
        }
        var content;
        var e;
        try {
            let controllerFile = this->projectDirectory . "controllers/" . Request::getCalledModule() . DIRECTORY_SEPARATOR . Request::getCalledController() . ".class.php";
            if (!file_exists(controllerFile)) {
                throw new NotFoundException("controller file not exist");
            }
            // beforeFilter
            if (beforeFilters) {
                this->filterExecute(beforeFilters);
            }
            ob_start();
            // Controller実行
            var controllerClassName;
            var controllerClass;
            require this->projectDirectory  . "controllers/CommonController.class.php";
            require controllerFile;
            let controllerClassName = "\\" . this->appName . "\\" . Request::getCalledController();
            let controllerClass = new {controllerClassName};
            this->ControllerExecute(controllerClass);
            Response::setContentBody(Response::getContentBody() . ob_get_contents());
            ob_end_clean();
            // afterFilter
            if (afterFilters) {
                this->filterExecute(afterFilters);
            }
        } catch NotFoundException, e {
            ob_end_clean();
            Response::setHttpStatus(Response::HTTP_NOT_FOUND);
            responseObj->sendHeader();
            if (this->isDebug) {
                var_dump(e);
            }
            exit();
        } catch KillException, e {
            Response::setContentBody(Response::getContentBody() . ob_get_contents());
            ob_end_clean();
            // レスポンスヘッダ設定
            responseObj->sendHeader();
            echo Response::getContentBody();
            exit();
        } catch RedirectException, e {
            ob_end_clean();
            try {
                responseObj->sendHeader();
            } catch KillException, e {
                exit();
            } catch \Exception, e {
                Response::setHttpStatus(Response::HTTP_INTERNAL_SERVER_ERROR);
                responseObj->sendHeader();
                if (this->isDebug) {
                    var_dump(e);
                }
                exit();
            }
        } catch \Exception, e {
            Response::setContentBody(Response::getContentBody() . ob_get_contents());
            ob_end_clean();
            if (file_exists(this->projectDirectory . "exception/ExceptionHandler.class.php")) {
                require this->projectDirectory . "exception/ExceptionHandler.class.php";
                var className;
                var ExceptionHandlerClass;
                let className = "\\" . this->appName . "\\ExceptionHandler";
                let ExceptionHandlerClass = new {className};
                ExceptionHandlerClass->handler(e);
            } else {
                if (e instanceof UnauthorizedException) {
                    Response::setHttpStatus(Response::HTTP_UNAUTHORIZED);
                } else {
                    Response::setHttpStatus(Response::HTTP_INTERNAL_SERVER_ERROR);
                }
                ob_start();
                var_dump(e);
                Response::setContentBody(ob_get_contents());
                ob_end_clean();
            }
            responseObj->sendHeader();
            if (this->isDebug) {
                echo Response::getContentBody();
            }
            exit();
        }
        let content = Response::getContentBody();
        // Content-Lengthの設定は本番だけ
        if (!this->isDebug) {
            Response::setHeader("Content-Length", strlen(content));
        }
        // レスポンスヘッダ設定
        responseObj->sendHeader();
        // 画面出力
        echo content;
        return;
    }

    /**
     * filter実行
     */
    private function filterExecute(array filtersArray) -> void
    {
        var filterName;
        var filterFileName;
        var filterClass;
        var e;
        for filterName in filtersArray {
            let filterFileName = this->projectDirectory . "filters/" . filterName . ".class.php";
            if (file_exists(filterFileName)) {
                let filterName = "\\" . this->appName . "\\" . filterName;
                if (!class_exists(filterName)) {
                    require filterFileName;
                }
                let filterClass = new {filterName};
                ob_start();
                try {
                    filterClass->execute();
                } catch \Exception, e {
                    Response::setContentBody(Response::getContentBody() . ob_get_contents());
                    ob_end_clean();
                    throw e;
                }
                Response::setContentBody(Response::getContentBody() . ob_get_contents());
                ob_end_clean();
            }
        }
    }

    /**
     * controller実行
     */
    private function controllerExecute(var controllerClass) -> void
    {
        var validateResult;
        var result;
        if (controllerClass->initialize() === false) {
            throw new KillException();
        }
        let validateResult = controllerClass->validate();
        if (is_array(validateResult)) {
            let result = true;
            var line;
            var v;
            for line in validateResult {
                for v in line {
                    if (v === false) {
                        let result = false;
                        break;
                    }
                }
                if (!result) {
                    break;
                }
            }
            if (!result) {
                controllerClass->validatorError(validateResult);
                return;
            }
        }
        controllerClass->action();
        return;
    }

    /**
     * バッチモード実行
     */
    public function doBatch(string className) -> void
    {
        // batch実行
        var batchFile;
        var tmpArray;
        var tmpClassName;
        var batch;
        if (!file_exists(this->projectDirectory . "batches/CommonBatch.class.php")) {
            throw new Exception("CommonBatch file not found");
        }
        let tmpArray = explode("\\", className);
        let tmpClassName = "";
        while (tmpClassName === "") {
            let tmpClassName = array_pop(tmpArray);
        }
        let batchFile = this->projectDirectory . "batches/" . tmpClassName . ".class.php";
        if (!file_exists(batchFile)) {
            throw new NotFoundException("batch file not found");
        }
        var e;
        var dump;
        try {
            // batch実行
            require this->projectDirectory . "batches/CommonBatch.class.php";
            require batchFile;
            let batch = new {className};
            batch->initialize();
            batch->execute();
        } catch KillException, e {
            exit();
        } catch \Exception, e {
            Logger::error("batch throw exception");
            ob_start();
            var_dump(e);
            let dump = ob_get_contents();
            ob_end_clean();
            Logger::error("exception dump : \n" . dump);
            if (this->isDebug) {
                echo dump;
            }
            try {
                batch->finally();
            } catch \Exception, e {
                ob_start();
                var_dump(e);
                let dump = ob_get_contents();
                ob_end_clean();
                Logger::error("exception(finally) dump : \n" . dump);
            }
            exit();
        }
        try {
            batch->finally();
        } catch \Exception, e {
            ob_start();
            var_dump(e);
            let dump = ob_get_contents();
            ob_end_clean();
            Logger::error("exception(finally) dump : \n" . dump);
        }
        return;
    }


    /**
     * デストラクタ
     */
    public function __destruct()
    {
    }
}
namespace Phate;

class PhpRenderer
{
    protected basePath;
    protected useCache;

    public function __construct(string basePath)
    {
        let this->basePath = basePath . DIRECTORY_SEPARATOR;
        let this->useCache = !Core::isDebug();
    }

    public function setUsingCache(bool isUsingCache) -> void
    {
        let this->useCache = isUsingCache;
    }

    public function unloadCache(string targetFileName) -> bool
    {
        var apcuCacheName;
        let apcuCacheName = "PhatePhpRandererCache:" . this->basePath . targetFileName;
        if (function_exists("apcu_delete")) {
            return apcu_delete(apcuCacheName);
        }
        return false;
    }

    public function execute(string targetFileName, array parameters = []) -> string
    {
        var evalString;
        var fileName;
        var apcuCacheName;
        let evalString = "";
        let fileName = this->basePath . targetFileName;
        let apcuCacheName = "PhatePhpRandererCache:" . fileName;
        if (function_exists("apcu_fetch") && this->useCache) {
            let evalString = apcu_fetch(apcuCacheName);
            if (evalString === false) {
                let evalString = "";
            }
        }
        if (evalString === "") {
            let evalString = file_get_contents(fileName);
            if (evalString === false) {
                throw new Exception("Php Renderer cant find template file");
            }
            if (function_exists("apcu_fetch") && this->useCache) {
                apcu_store(apcuCacheName, evalString);
            }
        }
        return this->executeString(evalString, parameters);
    }

    private function executeString(string evalString, array parameters = []) -> string
    {
        var content;
        var serializedParam;
        var executeString;
        var k;
        var e;
        for k in array_keys(parameters) {
            if (k === "phateParamKey" || k === "phateParamValue") {
                throw new Exception("PhpRenderer : cant use name of value \"" . k . "\"");
            }
        }
        let serializedParam = msgpack_serialize(parameters);
        let executeString = "";
        if (count(parameters) > 0 ) {
            let executeString = executeString . "$phateSerializedString = <<<PHATEENDOFDOCUMENT\n";
            let executeString = executeString . serializedParam . "\n";
            let executeString = executeString . "PHATEENDOFDOCUMENT;\n";
            let executeString = executeString . "$phateTmpArray = msgpack_unserialize($phateSerializedString); \n";
            let executeString = executeString . "if (is_array($phateTmpArray) & count($phateTmpArray) > 0 ) {\n";
            let executeString = executeString . "    foreach ($phateTmpArray as $phateParamKey => $phateParamValue) {\n";
            let executeString = executeString . "        ${$phateParamKey} = $phateParamValue;\n";
            let executeString = executeString . "    }\n";
            let executeString = executeString . "}\n";
        }
        let executeString = executeString . "?>" . evalString;
        ob_start();
        try {
            eval(executeString);
        } catch \Exception, e {
            ob_end_clean();
            throw new Exception(e->getMessage(), e->getCode(), e);
        }
        let content = ob_get_contents();
        ob_end_clean();
        return content;
    }

    public function render(string targetFileName, array parameters = []) -> void
    {
        echo this->execute(targetFileName, parameters);
    }
}

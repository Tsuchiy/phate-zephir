namespace Phate;

class Fluentd
{
    
    private static config = null;
    private static instanceList = [];

    /**
     * コンフィグ読み込み
     */
    private static function init() -> void
    {

        var fileName;
        let fileName = Core::getConfigure("logger_config_file", "");
        if (fileName === "") {
            throw new Exception("no logger configure");
        }
        if (!file_exists(Core::getConfigDir() . fileName)) {
            throw new Exception("no logger configure");
        }
        let self::config = Common::parseConfigYaml(Core::getConfigDir() . fileName);
    }

    /**
     * ターゲット名のインスタンスを取得
     */
    private static function getInstance(string targetName) -> <\SimpleFluent\Logger>
    {
        if (!array_key_exists(targetName, self::instanceList)) {
            if (is_null(self::config)) {
                self::init();
            }
            if (!array_key_exists(targetName, self::config)) {
                throw new Exception("no fluentd configure");
            }
            if (array_key_exists("socket", self::config[targetName])) {
                let self::instanceList[targetName] = new \SimpleFluent\Logger(self::config[targetName]["socket"]);
            } else {
                if (!array_key_exists("host", self::config[targetName])) {
                    throw new Exception("no fluentd configure");
                }
                if (array_key_exists("port", self::config[targetName])) {
                    let self::instanceList[targetName] = new \SimpleFluent\Logger(self::config[targetName]["host"], self::config[targetName]["port"]);
                } else {
                    let self::instanceList[targetName] = new \SimpleFluent\Logger(self::config[targetName]["host"]);
                }
            }



        }
        return self::instanceList[targetName];
    }

    /**
     * Fluentロガーに出力
     */
    public static function post(string targetName, string tag, array data)
    {
        var instance;
        let instance = self::getInstance(targetName);
        return instance->post(tag, data);
    }



}

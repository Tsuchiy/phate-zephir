namespace Phate;

class Logger
{

    const LEVEL_DEBUG = 1;
    const LEVEL_INFO = 2;
    const LEVEL_WARNING = 4;
    const LEVEL_ERROR = 8;
    const LEVEL_CRITICAL = 16;
    const LEVEL_FATAL = 128;
    
    const DEFAULT_PREFIX = "%s [%s] ";
    
    private static config;

    /**
     * ロガーの初期化
     */
    public static function init() -> void
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
     * Debugレベルログ出力
     */
    public static function debug(string str, bool freeFormat = false) -> bool
    {
        if (self::checkLoggingLevel(self::LEVEL_DEBUG)) {
            return self::outputFileLog("debug", str, freeFormat);
        }
        return false;
    }

    /**
     * Infoレベルログ出力
     */
    public static function info(string str, bool freeFormat = false) -> bool
    {
        if (self::checkLoggingLevel(self::LEVEL_INFO)) {
            return self::outputFileLog("info", str, freeFormat);
        }
        return false;
    }

    /**
     * Warningレベルログ出力
     */
    public static function warning(string str, bool freeFormat = false) -> bool
    {
        if (self::checkLoggingLevel(self::LEVEL_WARNING)) {
            return self::outputFileLog("warning", str, freeFormat);
        }
        return false;
    }

    /**
     * Errorレベルログ出力
     */
    public static function error(string str, bool freeFormat = false) -> bool
    {
        if (self::checkLoggingLevel(self::LEVEL_ERROR)) {
            return self::outputFileLog("error", str, freeFormat);
        }
        return false;
    }

    /**
     * Criticalレベルログ出力
     */
    public static function critical(string str, bool freeFormat = false) -> bool
    {
        if (self::checkLoggingLevel(self::LEVEL_CRITICAL)) {
            return self::outputFileLog("critical", str, freeFormat);
        }
        return false;
    }

    /**
     * ログレベルチェック
     */
    private static function checkLoggingLevel(int calledLevel) -> bool
    {
        var loggingLevel;
        let loggingLevel = Core::isDebug() ? self::config["debug_logging_level"] : self::config["normal_logging_level"];
        return (calledLevel & intval(loggingLevel)) !== 0;
    }

    /**
     * ファイルログ出力
     */
    private static function outputFileLog(string name, string str, bool freeFormat) -> bool
    {
        var outputPath;
        var outputFilename;
        var message;
        let outputPath = self::config[name]["log_file_path"];
        let outputFilename = self::config[name]["log_file_name"];
        if (freeFormat) {
            let message = str . "\n";
        } else {
            let message = sprintf(self::DEFAULT_PREFIX, Timer::getDateTime(), strtoupper(name));
            let message = message . str . "\n";
        }
        error_log(message, 3, outputPath . outputFilename);
        if (substr(sprintf("%o", fileperms(outputPath . outputFilename)), -4) !==  "06" . "66") {
            chmod(outputPath . outputFilename, 0666);
        }
        return true;
    }

    /**
     * Fatalレベルログ出力(PHP fatal error handler)
     */
    public static function fatal(int errno, string errstr, string errfile, int errline, array errorContext)
    {
        var name;
        let name = "fatal";
        var message;
        let message = sprintf(self::DEFAULT_PREFIX, Timer::getDateTime(), strtoupper(name));
        let message = message . "error_no:" . errno . " " . errstr ." ";
        let message = message . "(" . errfile ." , line:" . errline . ")\n";
        return self::outputFileLog(name, message, true);
    }

    /**
     * カスタムログ出力(マジックメソッド)
     * 適宜の名前のログ出力を行う
     */
    public static function __callStatic(string name, array arguments) -> bool
    {
        var str;
        var freeFormat;
        let str = count(arguments) > 0 ? array_shift(arguments) : "";
        let freeFormat = count(arguments) > 0 ? boolval(array_shift(arguments)) : false;
        return self::outputFileLog(name, str, freeFormat);
    }


}

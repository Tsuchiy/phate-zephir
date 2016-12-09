namespace Phate;

class Apcu
{
    
    private static config;
    private static invalid = false;
    
    /**
     * 設定ファイルよりapcuの設定を取得
     */
    private static function setConfig() -> void
    {
        var fileName;
        if (!function_exists("apcu_store")) {
            throw new Exception("no apcu module");
        }
        let fileName = Core::getConfigure("apcu_config_file", "");
        if (fileName === "") {
            throw new Exception("no apcu configure");
        }
        let self::config = Common::parseConfigYaml(Core::getConfigDir() . fileName);
        if (count(self::config) === 0) {
            throw new Exception("no apcu configure");
        }
    }
    
    /**
     * Apcuに値を格納
     */
    public static function set(string key, var value, var ttl = null, string cacheNameSpace = "default") 
    {
        var realTtl;
        var realKey;

        let realTtl = is_null(ttl) ? self::config[cacheNameSpace]["default_ttl"] : intval(ttl);
        let realKey = self::config[cacheNameSpace]["default_prefix"] . key;
        
        return apcu_store(realKey, Common::serialize(value), realTtl);
    }
    
    /**
     * Apcuより値を取得
     */
    public static function get(string key, string cacheNameSpace = "default")
    {
        var realKey;
        var tmp;
        if (self::invalid) {
            return false;
        }
        let realKey = self::config[cacheNameSpace]["default_prefix"] . key;
        let tmp = apcu_fetch(realKey);
        return tmp === false ? false : Common::unserialize(tmp);
    }
    
    /**
     * Apcuより値を消去
     */
    public static function delete(string key, string cacheNameSpace = "default")
    {
        var realKey;
        let realKey = self::config[cacheNameSpace]["default_prefix"] . key;
        return apcu_delete(realKey);
    }
    
    
    /**
     * Apcuより全てのキー一覧を取得（ただし保証はされない）
     */
    public static function getAllKeys(string cacheNameSpace = null)
    {
        var pattern;
        var apcuIterator;
        var rtn;
        var key;
        if (!is_null(cacheNameSpace)) {
            let pattern = "/^" . preg_quote(self::config[cacheNameSpace]["default_prefix"]) . "(.*)$/";
            let apcuIterator = new \APCUIterator(pattern);
        } else {
            let apcuIterator = new \APCUIterator();
        }
        let rtn = [];
        apcuIterator->rewind();
        let key = apcuIterator->key();
        while (key !== false) {
            let rtn[] = key;
            apcuIterator->next();
            let key = apcuIterator->key();
        }
        return rtn;
    }
    
    /**
     * Apcu機能の無効化を行う
     * debug時用
     *
     * @param boolean $disable disable
     *
     * @return integer
     */
    public static function setInvalid(bool disable = true)
    {
        let self::invalid = disable;
    }
}

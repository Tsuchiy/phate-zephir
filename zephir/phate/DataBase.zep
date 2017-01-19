namespace Phate;

class Database
{
    private static shardConfig = null;
    private static instanceConfig = null;
    private static instancePool = [];

    public static instanceReadOnly;
    public static instancePersistent;

    /**
     * 設定ファイルよりdatabaseの設定を取得
     **/
    protected static function setConfig() -> void
    {
        var fileName;
        var config;
        let fileName = Core::getConfigure("database_config_file", "");
        if (fileName === "") {
            throw new Exception("no database configure");
        }
        let self::instanceConfig = [];
        let self::shardConfig = [];
        let config = Common::parseConfigYaml(Core::getConfigDir() . fileName);
        if (!config) {
            throw new Exception("no database configure");
        }
        var key;
        var arr;
        for key, arr in config {
            self::developConfig(key, arr);
        }
    }

    /**
     * 設定の階層を展開
     **/
    private static function developConfig(string key, array value) -> void
    {
        var k;
        var v;
        if (array_key_exists("servers", value)) {
            let self::shardConfig[key] = array_keys(value["servers"]);
            for k,v in value["servers"] {
                self::developConfig(k, v);
            }
        } else {
            let self::instanceConfig[key] = value;
        }
        return;
    }

    /**
     * 接続名のDBObjインスタンスを返す
     **/
    public static function getInstance(string dbNameSpace) -> <DBObj>
    {
        var shardId;
        var dsn;
        var user;
        var password;
        var attr;
        var persistent;
        var instance;
        if (is_null(self::instanceConfig)) {
            self::setConfig();
        }

        if (!array_key_exists(dbNameSpace, self::instanceConfig)) {
            // sharding（というよりduplicate slave）の場合は任意のDBに
            if (array_key_exists(dbNameSpace, self::shardConfig)) {
                let shardId = mt_rand(0, self::getNumberOfShard(dbNameSpace) - 1);
                return self::getInstanceByShardId(dbNameSpace, shardId);
            }
            throw new DataBaseException("no database configure for namespace '" . dbNameSpace . "'");
        }
        if (!(array_key_exists(dbNameSpace, self::instancePool) && (self::instancePool[dbNameSpace] instanceof DBObj))) {
            let dsn  = "mysql:";
            let dsn .= "host=" . self::instanceConfig[dbNameSpace]["host"] . ";";
            let dsn .= "port=" . self::instanceConfig[dbNameSpace]["port"] . ";";
            let dsn .= "dbname=" . self::instanceConfig[dbNameSpace]["dbname"] . ";";
            let dsn .= "charset=utf8";
            let user = self::instanceConfig[dbNameSpace]["user"];
            let password = self::instanceConfig[dbNameSpace]["password"];
            let attr = [
                \PDO::ATTR_DEFAULT_FETCH_MODE : \PDO::FETCH_ASSOC,
                \PDO::ATTR_ERRMODE : \PDO::ERRMODE_EXCEPTION
            ];
            let persistent = false;
            if (array_key_exists("persistent", self::instanceConfig[dbNameSpace]) && (self::instanceConfig[dbNameSpace]["persistent"] === true)) {
                let attr[\PDO::ATTR_PERSISTENT] = true;
                let persistent = true;
            }
            let instance = new DBObj(dsn, user, password, attr);
            let self::instancePool[dbNameSpace] = instance;
            self::instancePool[dbNameSpace]->setNamespace(dbNameSpace);
            let self::instancePersistent[dbNameSpace] = persistent;
            let self::instanceReadOnly[dbNameSpace] = self::instanceConfig[dbNameSpace]["read_only"];
        }
        return self::instancePool[dbNameSpace];
    }

    /**
     * ShardのDBObjを取得
     **/
    public static function getInstanceByShardId(string dbNameSpace, int shardId) -> <DBObj>
    {
        var databaseName;
        if (is_null(self::shardConfig)) {
            self::setConfig();
        }
        if (!array_key_exists(dbNameSpace, self::shardConfig)) {
            throw new DataBaseException("no database configure for namespace'" . dbNameSpace . "'");
        }
        if (shardId >= count(self::shardConfig[dbNameSpace])) {
            throw new DataBaseException("no shard ID " . shardId . " on " . dbNameSpace);
        }
        let databaseName = self::shardConfig[dbNameSpace][shardId];
        return self::getInstance(databaseName);
    }

    /**
     * Shardの分割数を取得
     */
    public static function getNumberOfShard(string dbNameSpace) -> int
    {
        if (is_null(self::shardConfig)) {
            self::setConfig();
        }
        if (!array_key_exists(dbNameSpace, self::shardConfig)) {
            throw new DataBaseException("no database configure for namespace '" . dbNameSpace . "'");
        }
        return count(self::shardConfig[dbNameSpace]);
    }
}

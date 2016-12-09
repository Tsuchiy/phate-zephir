namespace Phate;

class Redis
{
    private static config = [];
    private static shardConfig = [];
    private static realInstancePool = [];
    private static configSerialize = [];
    
    /**
     * 設定ファイルよりredisの設定を取得
     *
     * @return void
     */
    public static function setConfig() -> void
    {
        var fileName;
        var config;
        var key;
        var arr;
        var serverName;
        var conf;
        // 必ずここは通るのでRedisモジュールの確認
        if (!class_exists("Redis")) {
            throw new Exception("no redis module");
        }
        let fileName = Core::getConfigure("redis_config_file", "");
        if (fileName === "") {
            throw new Exception("no redis configure");
        }
        let config = Common::parseConfigYaml(Core::getConfigDir() . fileName);
        if (count(config) === 0) {
            throw new Exception("no redis configure");
        }
        for key, arr in config {
            if (array_key_exists("servers", arr)) {
                let self::shardConfig[key] = array_keys(arr["servers"]);
                for serverName, conf in arr["servers"] {
                    let conf["database"] = array_key_exists("database", conf) ? conf["database"] : 0;
                    let self::config[serverName] = conf;
                }
            } else {
                let arr["database"] = array_key_exists("database", arr) ? arr["database"] : 0;
                let self::config[key] = arr;
            }
        }
    }
    /**
     * 接続先別のインスタンスを生成
     * @return Redis
     */
    private static function getRealInstance(string host, int port, int database, int readWriteTimeout = null, bool serialize = false, bool persistent = false) -> <\Redis>
    {
        var redis;
        var method;
        if (!isset(self::realInstancePool[host][port])) {
            let redis = new \Redis();
            let method = persistent ? "pconnect" : "connect";
            if (is_null(port) || port === 0) {
                if (is_null(readWriteTimeout) || readWriteTimeout === 0) {
                    redis->{method}(host);
                } else {
                    redis->{method}(host, readWriteTimeout);
                }
            } else {
                if (is_null(readWriteTimeout) || readWriteTimeout === 0) {
                    redis->{method}(host, port);
                } else {
                    redis->{method}(host, port, readWriteTimeout);
                }
            }
            let self::realInstancePool[host][port] = redis;
        }
        self::realInstancePool[host][port]->select(database);
        if (serialize === true) {
            if (function_exists("igbinary_serialize")) {
                self::realInstancePool[host][port]->setOption(\Redis::OPT_SERIALIZER, \Redis::SERIALIZER_IGBINARY);
            } else {
                self::realInstancePool[host][port]->setOption(\Redis::OPT_SERIALIZER, \Redis::SERIALIZER_PHP);
            }
        } else {
            self::realInstancePool[host][port]->setOption(\Redis::OPT_SERIALIZER, \Redis::SERIALIZER_NONE);
        }
        return self::realInstancePool[host][port];
    }

    /**
     * 接続名のインスタンスを返す
     */
    public static function getInstance(string dbNameSpace) -> <\Redis>
    {
        var configures;
        var serverName;
        var serverConfig;
        var instance;
        var host;
        var port;
        var readWriteTimeout;
        var database;
        var serialize;
        var persistent;
        var e;
        // config読み込み
        if (count(self::config) === 0) {
            self::setConfig();
        }
        if (!array_key_exists(dbNameSpace, self::config) && !array_key_exists(dbNameSpace, self::shardConfig)) {
            throw new RedisException("cant resolve namespace on redis");
        }
        // レプリケーションしている時は接続分散and死活判定用に設定展開
        if (isset(self::config[dbNameSpace])) {
            let configures = [dbNameSpace : self::config[dbNameSpace]];
        } else {
            let configures = [];
            shuffle(self::shardConfig[dbNameSpace]);
            for serverName in self::shardConfig[dbNameSpace] {
                if (!isset(self::config[serverName])) {
                    throw new RedisException("illegal config on redis");
                }
                let configures[serverName] = self::config[serverName];
            }
        }
        let instance = null;
        // インスタンス接続（sentinel対応）
        for serverConfig in configures {
            try {
                echo "jire";
                if (array_key_exists("domain", serverConfig)) {
                    let host = serverConfig["domain"];
                    let port = null;
                    let readWriteTimeout = null;
                } else {
                    let host = serverConfig["host"];
                    let port = serverConfig["port"];
                    let readWriteTimeout = array_key_exists("read_write_timeout", serverConfig) ? serverConfig["read_write_timeout"] : null;
                }
                let database = array_key_exists("database", serverConfig) ? serverConfig["database"] : 0;
                let serialize = array_key_exists("serialize", serverConfig) ? serverConfig["serialize"] : true;
                let persistent = array_key_exists("persistent", serverConfig) ? serverConfig["persistent"] : false;
                let instance = self::getRealInstance(host, port, database, readWriteTimeout, serialize, persistent);
                break;
            } catch \RedisException, e {
                let instance = null;
                continue;
            }
        }
        // 全部に接続確立できてない
        if (is_null(instance)) {
            throw new RedisException("namespace : " . dbNameSpace);
        }
        return instance;
    }


}
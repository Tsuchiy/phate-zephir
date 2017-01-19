namespace Phate;

class Memcached
{
    
    private static config = [];
    private static realInstancePool;
    private static instancePool;
    private static instancePool4Set;
    private static invalid = false;
    
    /**
     * 設定ファイルよりmemcacheの設定を取得
     */
    private static function setConfig()
    {
        var fileName;
        if (!class_exists("\\Memcached")) {
            throw new Exception("no memcached class(use pecl install)");
        }
        if (defined("\\Memcached::HAVE_MSGPACK") && (\Memcached::HAVE_MSGPACK === 1)) {
            ini_set("memcached.serializer", "msgpack");
        } elseif (defined("\\Memcached::HAVE_IGBINARY") && (\Memcached::HAVE_IGBINARY === 1)) {
            ini_set("memcached.serializer", "igbinary");
        }
        let fileName = Core::getConfigure("memcache_config_file", "");
        if (fileName === "") {
            throw new Exception("no memcache configure");
        }
        let self::config = Common::parseConfigYaml(Core::getConfigDir() . fileName);
        if (count(self::config) === 0) {
            throw new Exception("no memcache configure");
        }
    }

    /**
     * 接続先別のインスタンスを生成
     *
     * @param string  $host host url
     * @param integer $port port
     *
     * @return \Memcached
     */
    private static function getRealInstance(string host, int port) -> <\Memcached>
    {
        var m;
        if (!isset(self::realInstancePool[host][port])) {
            let m = new \Memcached;
            m->setOption(\Memcached::OPT_CONNECT_TIMEOUT, 1000);
            m->setOption(\Memcached::OPT_SEND_TIMEOUT, 1000);
            m->setOption(\Memcached::OPT_RECV_TIMEOUT, 1000);
            m->addServer(host, port);
            // 疎通確認
            m->getVersion();
            if (m->getResultCode() !== \Memcached::RES_SUCCESS) {
                throw new MemcachedException();
            }
            let self::realInstancePool[host][port] = m;
        }
        return self::realInstancePool[host][port];
    }

    /**
     * 接続名のインスタンスを返す
     */
    private static function getInstance(string cacheNameSpace) -> <\Memcached>
    {
        var instance;
        var instance4Set;
        var serverConfig;
        var tmpInstance;
        var e;
        if (!isset(self::instancePool[cacheNameSpace])) {
            if (count(self::config) === 0) {
                self::setConfig();
            }
            if (!isset(self::config[cacheNameSpace])) {
                throw new MemcachedException("cant resolve namespace on memcached");
            }
            let instance = null;
            let instance4Set = [];
            // レプリケーション対応
            for serverConfig in self::config[cacheNameSpace]["servers"] {
                try {
                    let tmpInstance = self::getRealInstance(serverConfig["host"], serverConfig["port"]);
                    if (is_null(instance)) {
                        let instance = tmpInstance;
                    }
                    let instance4Set[] = tmpInstance;
                } catch MemcachedConnectFailException, e {
                    continue;
                }
            }
            // 全部に接続確立できてない
            if (is_null(instance)) {
                throw new MemcachedException("cant connection all namespace on memcached");
            }
            let self::instancePool[cacheNameSpace] = instance;
            let self::instancePool4Set[cacheNameSpace] = instance4Set;
        }
        return self::instancePool[cacheNameSpace];
    }

    /**
     * 接続名の全てのインスタンスを返す
     */
    private static function getInstance4Set(string cacheNameSpace) -> array
    {
        if (!isset(self::instancePool4Set[cacheNameSpace])) {
            self::getInstance(cacheNameSpace);
        }
        return self::instancePool4Set[cacheNameSpace];
    }

    /**
     * インスタンスプールにあるmemcachedオブジェクトを全て明示的に切断する
     */
    public static function disconnect()
    {
        var host;
        var port;
        var tmp;
        var v;
        if (!is_array(self::realInstancePool)) {
            return;
        }
        // 存在するインスタンスを全部切断する
        for host, tmp in self::realInstancePool {
            for port, v in tmp {
                self::realInstancePool[host][port]->quit();
                unset(self::realInstancePool[host][port]);
            }
        }
    }
    /**
     * Memcacheに値を格納
     * バックアップサーバ対策？のためにキーを全サーバに保存しに行く
     */
    public static function set(string key, var value, var expiration = null, string cacheNameSpace = "default") -> bool
    {
        var memcachedList;
        var memcached;
        var rtn;
        let memcachedList = self::getInstance4Set(cacheNameSpace);
        if (is_null(expiration)) {
            let expiration = self::config[cacheNameSpace]["default_expire"];
        } else {
            let expiration = intval(expiration);
        }
        let rtn = true;
        for memcached in memcachedList {
            if ((memcached->set(self::config[cacheNameSpace]["default_prefix"] . key, value, expiration)) === false) {
                let rtn = false;
            }
        }
        return rtn;
    }
    /**
     * Memcacheに値を複数格納
     * バックアップサーバ対策？のためにキーを全サーバに保存しに行く
     */
    public static function setMulti(array items, var expiration = null, string cacheNameSpace = "default") -> bool
    {
        var realItems;
        var memcachedList;
        var memcached;
        var rtn;
        var key;
        var value;
        if (count(self::config) === 0) {
            self::setConfig();
        }
        if (is_null(expiration)) {
            let expiration = self::config[cacheNameSpace]["default_expire"];
        } else {
            let expiration = intval(expiration);
        }
        let realItems = [];
        for key,value in items {
            let realItems[self::config[cacheNameSpace]["default_prefix"] . key] = value;
        }
        let memcachedList = self::getInstance4Set(cacheNameSpace);
        let rtn = true;
        for memcached in memcachedList {
            if ((memcached->setMulti(realItems, expiration)) === false) {
                let rtn = false;
            }
        }
        return rtn;
    }

    /**
     * Memcacheより値を取得
     *
     * @param string   $key       key
     * @param string   cacheNameSpace connection namespace
     * @param function $cache_cb  cache callback
     * @param string   $cas_token CAS Token
     *
     * @return mixed/false
     */
    public static function get(string key, string cacheNameSpace = "default")
    {
        if (self::invalid) {
            return false;
        }
        return self::getInstance(cacheNameSpace)->get(self::config[cacheNameSpace]["default_prefix"] . key);
    }
    /**
     * Memcacheより値を配列で取得
     */
    public static function getMulti(array keys, string cacheNameSpace = "default") -> bool|array
    {
        var rtn;
        var key;
        var value;
        var realKeys;
        var reverseKeys;
        var res;
        let rtn = [];
        if (self::invalid) {
            for key in keys {
                let rtn[key] = false;
            }
            return rtn;
        }

        if (count(self::config) === 0) {
            self::setConfig();
        }
        let realKeys = [];
        let reverseKeys = [];
        for key in keys {
            let realKeys[key] = self::config[cacheNameSpace]["default_prefix"] . key;
            let reverseKeys[self::config[cacheNameSpace]["default_prefix"] . key] = key;
        }
        let res = self::getInstance(cacheNameSpace)->getMulti(keys);
        if (res === false) {
            return false;
        }
        for key,value in res {
            let rtn[reverseKeys[key]] = value;
        }
        return rtn;
    }

    /**
     * Memcacheより値を消去
     * バックアップ対策？のためにキーを全サーバに削除しに行く
     *
     * @param string $key       key
     * @param string cacheNameSpace connection namespace
     *
     * @return boolean
     */
    public static function delete(string key, string cacheNameSpace = "default")
    {
        var memcachedList;
        var memcached;
        var rtn;
        let memcachedList = self::getInstance4Set(cacheNameSpace);
        let rtn = true;
        for memcached in memcachedList {
            if ((memcached->delete(self::config[cacheNameSpace]["default_prefix"] . key)) === false) {
                if (memcached->getResultCode() !== \Memcached::RES_NOTFOUND) {
                    let rtn = false;
                }
            }
        }
        return rtn;
    }

    /**
     * Memcacheより値を配列で消去
     * バックアップ対策？のためにキーを全サーバに削除しに行く
     */
    public static function deleteMulti(array keys, string cacheNameSpace = "default") -> bool
    {
        var memcachedList;
        var memcached;
        var rtn;
        var key;
        var realKeys;
        if (count(self::config) === 0) {
            self::setConfig();
        }
        let realKeys = [];
        for key in keys {
            let realKeys[] = self::config[cacheNameSpace]["default_prefix"] . key;
        }

        let memcachedList = self::getInstance4Set(cacheNameSpace);
        let rtn = true;
        for memcached in memcachedList {
            if ((memcached->deleteMulti(realKeys)) === false) {
                if (memcached->getResultCode() !== \Memcached::RES_NOTFOUND) {
                    let rtn = false;
                }
            }
        }
        return rtn;
    }
    
    /**
     * Memcacheより全てのキー一覧を取得（ただし保証はされない）
     */
    public static function getAllKeys(string cacheNameSpace = "default") -> array
    {
        var realKey;
        var realKeys;
        var rtn;
        var pattern;

        let realKeys = self::getInstance(cacheNameSpace)->getAllKeys();
        let rtn = [];
        let pattern = "/^" . preg_quote(self::config[cacheNameSpace]["default_prefix"]) . "(.*)$/";
        for realKey in realKeys {
            if (preg_match(pattern, realKey)) {
                let rtn[] = preg_replace(pattern, "$1", realKey);
            }
        }
        return rtn;
    }

    /**
     * 直前のmemcached結果コードを取得
     * バックアップ対策？のために全サーバに更新処理をかけているので、
     * 必ずしも意図した値は保証されないかもしれない
     */
    public static function getResultCode(string cacheNameSpace = "default") -> int
    {
        return self::getInstance(cacheNameSpace)->getResultCode();
    }

    /**
     * Memcache機能の無効化を行う
     * debug時用
     */
    public static function setInvalid(bool disable = true) -> void
    {
        let self::invalid = disable;
    }

    /**
     * 名前空間にある全てのキーを削除する
     */
    public static function flush(string cacheNameSpace = "default", int delay = 0) -> bool
    {
        var items;
        if (delay === 0) {
            return Memcached::deleteMulti(Memcached::getAllKeys(cacheNameSpace), cacheNameSpace);
        }
        let items = Memcached::getMulti(Memcached::getAllKeys(cacheNameSpace), cacheNameSpace);
        return Memcached::setMulti($items, $delay);
    }
}

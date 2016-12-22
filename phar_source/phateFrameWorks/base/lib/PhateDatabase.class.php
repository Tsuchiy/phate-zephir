<?php
/**
 * PhateDBクラスファイル
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 **/
namespace Phate;

/**
 * DBクラス
 *
 * 設定ファイルを元にDBへの接続済みのDBOを作成するクラス
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 * @create   2014/11/13
 **/
class Database
{
    private static $_shardConfig;
    private static $_instanceConfig;
    private static $_instancePool;
    public static $instanceReadOnly;
    public static $instancePersistent;
    
    /**
     * 設定ファイルよりdatabaseの設定を取得
     *
     * @return void
     **/
    protected static function setConfig()
    {
        if (!($fileName = Core::getConfigure('database_config_file'))) {
            throw new CommonException('no database configure');
        }
        if (!($config = Common::parseConfigYaml(PHATE_CONFIG_DIR . $fileName))) {
            throw new CommonException('no database configure');
        }
        
        foreach ($config as $key => $arr) {
            self::_developConfig($key, $arr);
        }
    }
    /**
     * 設定の階層を展開
     *
     * @param string $key   key
     * @param array  $value value
     *
     * @return void
     **/
    private static function _developConfig($key, array $value)
    {
        if (array_key_exists('servers', $value)) {
            self::$_shardConfig[$key] = array_keys($value['servers']);
            foreach ($value['servers'] as $k => $v) {
                self::_developConfig($k, $v);
            }
        } else {
            self::$_instanceConfig[$key] = $value;
        }
        return;
    }
    
    /**
     * 接続名のPDOインスタンスを返す
     *
     * @param string $namespace connection namespace
     *
     * @return DBO DBObject
     **/
    public static function getInstance($namespace)
    {
        if (!self::$_instanceConfig) {
            self::setConfig();
        }
        if (!in_array($namespace, array_keys(self::$_instanceConfig))) {
            // シャーディング（というよりデュプリケートスレーブ）の場合は任意のDBに
            if (in_array($namespace, array_keys(self::$_shardConfig))) {
                $shardId = mt_rand(0, self::getNumberOfShard($namespace) - 1);
                return self::getInstanceByShardId($namespace, $shardId);
            }
            throw new DatabaseException('no database configure for namespace"' . $namespace . '"');
        }
        if (!isset(self::$_instancePool[$namespace])) {
            $dsn  = 'mysql:';
            $dsn .= 'host=' . self::$_instanceConfig[$namespace]['host'] . ';';
            $dsn .= 'port=' . self::$_instanceConfig[$namespace]['port'] . ';';
            $dsn .= 'dbname=' . self::$_instanceConfig[$namespace]['dbname'] . ';';
            $dsn .= 'charset=utf8';
            $user = self::$_instanceConfig[$namespace]['user'];
            $password = self::$_instanceConfig[$namespace]['password'];
            $attr = [
                \PDO::ATTR_DEFAULT_FETCH_MODE => \PDO::FETCH_ASSOC,
                \PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION,
            ];
            $persistent = false;
            if (array_key_exists('persistent', self::$_instanceConfig[$namespace]) && (self::$_instanceConfig[$namespace]['persistent'] == true)) {
                $attr[\PDO::ATTR_PERSISTENT] = true;
                $persistent = true;
            }
            $instance = new DBO($dsn, $user, $password, $attr);
            self::$_instancePool[$namespace] = $instance;
            self::$_instancePool[$namespace]->setNamespace($namespace);
            self::$instancePersistent[$namespace] = $persistent;
            self::$instanceReadOnly[$namespace] = self::$_instanceConfig[$namespace]['read_only'];
        }
        return self::$_instancePool[$namespace];
    }

    /**
     * ShardのDBOを取得
     *
     * @param string $namespace connection namespace
     * @param int    $shardId   shard ID
     *
     * @return DBO DBObject
     **/
    public static function getInstanceByShardId($namespace, $shardId)
    {
        if (!self::$_shardConfig) {
            self::setConfig();
        }
        if (!in_array($namespace, array_keys(self::$_shardConfig))) {
            throw new DatabaseException('no database configure for namespace"' . $namespace . '"');
        }
        if (!in_array($shardId, array_keys(self::$_shardConfig[$namespace]))) {
            throw new DatabaseException('no shard ID " ' . $shardId . ' on ' . $namespace . '"');
        }
        $databaseName = self::$_shardConfig[$namespace][$shardId];
        return self::getInstance($databaseName);
    }
    
    /**
     * Shardの分割数を取得
     *
     * @param string $namespace connection namespace
     *
     * @return int
     **/
    public static function getNumberOfShard($namespace)
    {
        if (!self::$_shardConfig) {
            self::setConfig();
        }
        if (!in_array($namespace, array_keys(self::$_shardConfig))) {
            throw new DatabaseException('no database configure for namespace"' . $namespace . '"');
        }
        return count(self::$_shardConfig[$namespace]);
    }
    
    /**
     * インスタンスプールのコネクトを切断する
     *
     * @return void
     **/
    public static function disconnect()
    {
        if (!isset(self::$_instancePool) || !is_array(self::$_instancePool)) {
            return;
        }
        foreach (self::$_instancePool as $key => $instance) {
            if (!self::$instancePersistent[$key]) {
                unset(self::$_instancePool[$key]);
            }
        }
        unset($instance);
    }
}

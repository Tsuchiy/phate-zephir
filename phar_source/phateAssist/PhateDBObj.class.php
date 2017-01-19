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
 * DBObjクラス
 *
 * PDObjクラスにPearライクなメソッドを幾つか追加したDBObject
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
  * @create   2016/12/23
 **/
class DBObj extends \PDO
{

    /**
     * 接続namespaceをセットする
     *
     * @param string dbNamespace
     *
     * @return void
     **/
    public function setNamespace($dbNamespace);
   
    /**
     * 接続namespaceをゲットする
     *
     * @return string
     **/
    public function getNamespace();

    /**
     * このインスタンスがread onlyかを返す
     *
     * @return bool
     **/
    public function isReadOnly();
   
    /**
     * このインスタンスがpersistentかを返す
     *
     * @return bool
     **/
    public function isPersistent();

   
    /**
     * 多重トランザクション対応
     *
     * @return bool
     **/
    public function beginTransaction();

    /**
     * 多重トランザクション対応
     *
     * @return bool
     **/
    public function commit();

    /**
     * 多重トランザクション対応
     *
     * @return bool
     **/
    public function rollBack();

    /**
     * SQLの実行
     *
     * @param string $sql
     * @param array  $params
     *
     * @return bool
     **/
    public function executeSql(string $sql, array $params = []);

    /**
     * SQLを実行し、1行取得する
     *
     * @param string $sql
     * @param array  $params
     *
     * @return bool|array
     **/
    public function getRow(string $sql, array $params = []);

    /**
     * SQLを実行し、全行取得する
     *
     * @param string $sql
     * @param array  $params
     *
     * @return bool|array
     **/
    public function getAll(string $sql, array $params = []);

    /**
     * SQLを実行し、最初の1カラムを取得する
     *
     * @param string $sql
     * @param array  $params
     *
     * @return mixed
     **/
    public function getOne(string $sql, array $params = []);

   
    /**
     * SQLを実行し、指定したカラムを配列として取得する
     *
     * @param string $sql
     * @param string $columnName
     * @param array  $params
     *
     * @return array
     **/
    public function getCol(string $sql, string $columnName, array $params = []);

    /**
     * MySQLでmultipul insertを行う
     *
     * @param string $tableName
     * @param array  $dataArray
     * @param array  $columnList
     *
     * @return bool
     **/
    public function multipulInsert(string $tableName, array $dataArray, array $columnList = []);
}

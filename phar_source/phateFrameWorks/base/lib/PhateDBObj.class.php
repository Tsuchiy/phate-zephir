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
 * @create   2014/11/13
 **/
class DBObj extends \PDO
{
    protected $namespace = '';
    protected $transactionLevel = 0;
    protected $rollbackFlg = false;
    
    /**
     * 接続namespaceをセットする
     *
     * @param String $namespace connection namespace
     *
     * @return void
     **/
    public function setNamespace($namespace)
    {
        $this->namespace = $namespace;
    }
    
    /**
     * 接続namespaceをゲットする
     *
     * @return String $namespace
     **/
    public function getNamespace()
    {
        return $this->namespace;
    }
    
    /**
     * このインスタンスがreadonlyかを返す
     *
     * @return boolean
     **/
    public function isReadOnly()
    {
        return DB::$instanceReadOnly[$this->getNamespace()];
    }
    
    /**
     * このインスタンスがpersistentかを返す
     *
     * @return boolean
     **/
    public function isPersistent()
    {
        return DB::$instancePersistent[$this->getNamespace()];
    }
    
    /**
     * 多重トランザクション対応
     *
     * @return boolean
     **/
    public function beginTransaction()
    {
        if ($this->transactionLevel < 0) {
            throw new DatabaseException('begin transaction exception');
        }
        if ($this->transactionLevel === 0) {
            if (parent::beginTransaction() === true) {
                ++$this->transactionLevel;
                return true;
            }
            return false;
        }
        ++$this->transactionLevel;
        return true;
    }

    /**
     * 多重トランザクション対応
     *
     * @return boolean
     **/
    public function commit()
    {
        if (--$this->transactionLevel === 0) {
            if ($this->rollbackFlg) {
                throw new DatabaseException('rollback called before commit (multi transaction)');
            }
            return parent::commit();
        } elseif ($this->transactionLevel < 0) {
            throw new DatabaseException('commit,in not toransaction');
        }
        return true;
    }
    
    /**
     * 多重トランザクション対応
     *
     * @return boolean
     **/
    public function rollBack()
    {
        if (--$this->transactionLevel === 0) {
            $this->rollbackFlg = false;
            return parent::rollBack();
        } elseif ($this->transactionLevel < 0) {
            throw new DatabaseException('rollback,in not toransaction');
        }
        $this->rollbackFlg = true;
        return true;
    }

    /**
     * SQLの実行
     *
     * @param string $sql    sql
     * @param array  $params placeholder parameters
     *
     * @return boolean
     **/
    public function executeSql($sql, array $params = [])
    {
        if (($stmt = $this->prepare($sql)) === false) {
            return false;
        }
        return $stmt->execute($params);
    }
    
    /**
     * SQLを実行し結果を一行取得する
     *
     * @param type  $sql    sql
     * @param array $params placeholder parameters
     *
     * @return boolean|array
     **/
    public function getRow($sql, array $params = [])
    {
        if (($stmt = $this->prepare($sql)) === false) {
            return false;
        }
        if ($stmt->execute($params) === false) {
            return false;
        }
        return $stmt->fetch();
    }
    
    /**
     * SQLを実行し、全行取得する
     *
     * @param string $sql    sql
     * @param array  $params placeholder parameters
     *
     * @return boolean|array
     **/
    public function getAll($sql, array $params = [])
    {
        if (($stmt = $this->prepare($sql)) === false) {
            return false;
        }
        //echo $sql;
        if ($stmt->execute($params) === false) {
            return false;
        }
        return $stmt->fetchAll();
    }
    
    /**
     * SQLを実行し、最初の1カラムを取得する
     *
     * @param string $sql    sql
     * @param array  $params placeholder parameters
     *
     * @return boolean/string
     **/
    public function getOne($sql, array $params = [])
    {
        if (($stmt = $this->prepare($sql)) === false) {
            return false;
        }
        if ($stmt->execute($params) === false) {
            return false;
        }
        return $stmt->fetchColumn();
    }
    
    /**
     * SQLを実行し、指定したカラムを配列として取得する
     *
     * @param stiring $sql        sql
     * @param string  $columnName target column
     * @param array   $params     placeholder parameters
     *
     * @return boolean|array
     **/
    public function getCol($sql, $columnName, array $params = [])
    {
        if (($stmt = $this->prepare($sql)) === false) {
            return false;
        }
        if ($stmt->execute($params) === false) {
            return false;
        }
        $all = $stmt->fetchAll();
        if ($all === false) {
            return false;
        }
        $rtn = [];
        foreach ($all as $v) {
            $rtn[] = $v[$columnName];
        }
        return $rtn;
    }
    
    /**
     * 疑似でreplace into 文を実行する
     *
     * @param string $tableName table name
     * @param array  $keyParams key parameters
     * @param array  $params    parameters
     *
     * @return boolean
     **/
    public function replace($tableName, array $keyParams, array $params = [])
    {
        if ($keyParams) {
            $whereClause = ' WHERE ';
            $bindKeyValues = array();
            foreach ($keyParams as $k => $v) {
                $whereClause .= count($bindKeyValues) == 0 ? '' : ' AND ';
                $whereClause .= $k . ' = ? ';
                $bindKeyValues[] = $v;
            }
            $sql = 'SELECT count(1) as cnt FROM ' . $tableName . $whereClause;
            $cnt = $this->getOne($sql, $keyParams);
            $bindValues = array();
        } else {
            $cnt = 0;
        }
        if ($cnt > 0) {
            // update
            $paramClause = '';
            foreach ($params as $k => $v) {
                $paramClause .= $paramClause == '' ? ' SET ' : ' , ';
                $paramClause .= $k . ' = ? ';
                $bindValues[]  = $v;
            }
            $sql = 'UPDATE ' . $tableName . $paramClause . $whereClause;
            $bindValues = array_merge($bindValues, $bindKeyValues);
        } else {
            // insert
            $columnClause = '';
            $bindClause = '';
            foreach ($keyParams as $k => $v) {
                $columnClause .= $columnClause ? ' , ' : ' ( ';
                $bindClause .= $bindClause ? ' , ' : ' VALUES ( ';
                $columnClause .= $k;
                $bindClause .= '?';
                $bindValues[] = $v;
            }
            foreach ($params as $k => $v) {
                $columnClause .= ',' . $k;
                $bindClause .= ' , ?';
                $bindValues[] = $v;
            }
            $columnClause .= ' ) ';
            $bindClause .= ' ) ';
            $sql = 'INSERT INTO ' . $tableName . $columnClause . $bindClause;
        }
        return $this->executeSql($sql, $bindValues);
    }
    
    /**
     * MySQLでmultipul insertを行う
     *
     * @param string $tableName  table name
     * @param array  $dataArray  data array
     * @param array  $columnList target columns
     *
     * @return boolean
     *
     * @throws DatabaseSQLException
     **/
    public function multipulInsert($tableName, array $dataArray, array $columnList = [])
    {
        $param = [];
        if ($columnList) {
            $valueSql = '';
            $tmpArray = array_pad([], count($columnList), '?');
            foreach ($dataArray as $dataRow) {
                $valueSql .=',(' . implode(',', $tmpArray) . ')';
                foreach ($columnList as $column) {
                    if (($param[] = array_shift($dataRow)) === false) {
                        throw new DatabaseSQLException('illegal data array');
                    }
                }
            }
            $sql = 'INSERT INTO ' . $tableName . ' (`' . implode('`,`', $columnList) . '`) VALUES ' . substr($valueSql, 1);
        } else {
            $columns = [];
            foreach ($dataArray as $dataRow) {
                $columns = array_unique(array_merge($columns, array_keys($dataRow)));
            }
            $valueSql = '';
            $tmpArray = array_pad([], count($columns), '?');
            foreach ($dataArray as $dataRow) {
                $valueSql .=',(' . implode(',', $tmpArray) . ')';
                foreach ($columns as $column) {
                    $param[] = isset($dataRow[$column]) ? $dataRow[$column] : null;
                }
            }
            $sql = 'INSERT INTO ' . $tableName . ' (`' . implode('`,`', $columns) . '`) VALUES ' . substr($valueSql, 1);
        }
        
        return $this->executeSql($sql, $param);
    }
}

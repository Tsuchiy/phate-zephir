namespace Phate;

class DBObj extends \PDO
{

    protected dbNamespace = "";
    protected transactionLevel = 0;
    protected rollbackFlg = false;

    /**
     * 接続namespaceをセットする
     **/
    public function setNamespace(string dbNamespace) -> void
    {
        let this->dbNamespace = dbNamespace;
    }
    
    /**
     * 接続namespaceをゲットする
     **/
    public function getNamespace() -> string
    {
        return this->dbNamespace;
    }

    /**
     * このインスタンスがread onlyかを返す
     **/
    public function isReadOnly() -> bool
    {
        return Database::instanceReadOnly[this->dbNamespace];
    }
    
    /**
     * このインスタンスがpersistentかを返す
     **/
    public function isPersistent() -> bool
    {
        return Database::instancePersistent[this->dbNamespace];
    }

    
    /**
     * 多重トランザクション対応
     **/
    public function beginTransaction() -> bool
    {
        if (this->transactionLevel < 0) {
            throw new DataBaseException("begin transaction exception");
        }
        if (this->transactionLevel === 0) {
            if (parent::beginTransaction() === true) {
                let this->transactionLevel++;
                return true;
            }
            return false;
        }
        let this->transactionLevel++;
        return true;
    }
    

    /**
     * 多重トランザクション対応
     **/
    public function commit() -> bool
    {
        let this->transactionLevel--;
        if (this->transactionLevel === 0) {
            if (this->rollbackFlg) {
                throw new DataBaseException("rollback called before commit (multi transaction)");
            }
            return parent::commit();
        } elseif (this->transactionLevel < 0) {
            throw new DataBaseException("commit,in not toransaction");
        }
        return true;
    }    

    /**
     * 多重トランザクション対応
     **/
    public function rollBack() -> bool
    {
        let this->transactionLevel--;
        if (this->transactionLevel === 0) {
            let this->rollbackFlg = false;
            return parent::rollBack();
        } elseif (this->transactionLevel < 0) {
            throw new DataBaseException("rollback,in not toransaction");
        }
        let this->rollbackFlg = true;
        return true;
    }

    /**
     * SQLの実行
     **/
    public function executeSql(string sql, array params = []) -> bool
    {
        var stmt;
        let stmt = this->prepare(sql);
        if (stmt === false) {
            return false;
        }
        return stmt->execute(params);
    }

    /**
     * SQLを実行し、1行取得する
     **/
    public function getRow(string sql, array params = []) -> bool|array
    {
        var stmt;
        let stmt = this->prepare(sql);
        if (stmt === false) {
            return false;
        }
        if (stmt->execute(params) === false) {
            return false;
        }
        return stmt->$fetch();
    }

    /**
     * SQLを実行し、全行取得する
     **/
    public function getAll(string sql, array params = []) -> bool|array
    {
        var stmt;
        let stmt = this->prepare(sql);
        if (stmt === false) {
            return false;
        }
        if (stmt->execute(params) === false) {
            return false;
        }
        return stmt->fetchAll();
    }


    /**
     * SQLを実行し、最初の1カラムを取得する
     **/
    public function getOne(string sql, array params = [])
    {
        var stmt;
        let stmt = this->prepare(sql);
        if (stmt === false) {
            return false;
        }
        if (stmt->execute(params) === false) {
            return false;
        }
        return stmt->fetchColumn();
    }

    
    /**
     * SQLを実行し、指定したカラムを配列として取得する
     **/
    public function getCol(string sql, string columnName, array params = []) -> bool|array
    {
        var stmt;
        var rtn;
        var allData;
        let stmt = this->prepare(sql);
        if (stmt === false) {
            return false;
        }
        if (stmt->execute(params) === false) {
            return false;
        }
        let allData = stmt->fetchAll(\PDO::FETCH_ASSOC);
        if (allData === false) {
            return false;
        }
        let rtn = [];
        var v;
        for v in allData {
            let rtn[] = v[columnName];
        }
        return rtn;
    }

    /**
     * MySQLでmultipul insertを行う
     **/
    public function multipulInsert(string tableName, array dataArray, array columnList = []) -> bool
    {
        var sql;
        var param;
        var column;
        var columns;
        var valueSql;
        var tmpArray;
        var dataRow;
        var tmpVal;

        let param = [];
        if (count(columnList) > 0) {
            let valueSql = "";
            let tmpArray = array_pad([], count(columnList), "?");
            for dataRow in dataArray {
                let valueSql .= ",(" . implode(",", tmpArray) . ")";
                for column in columnList {
                    let tmpVal = array_shift(dataRow);
                    if (tmpVal === false) {
                        throw new DataBaseException("illegal data array");
                    }
                    let param[] = tmpVal;
                }
            }
            let sql = "INSERT INTO " . tableName . " (`" . implode("`,`", columnList) . "`) VALUES " . substr(valueSql, 1);
        } else {
            let columns = [];
            for dataRow in dataArray {
                let columns = array_unique(array_merge(columns, array_keys(dataRow)));
            }
            let valueSql = "";
            let tmpArray = array_pad([], count(columns), "?");
            for dataRow in dataArray {
                let valueSql .= ",(" . implode(",", tmpArray) . ")";
                for column in columns {
                    let param[] = array_key_exists(column, dataRow) ? dataRow[column] : null;
                }
            }
            let sql = "INSERT INTO " . tableName . " (`" . implode("`,`", columns) . "`) VALUES " . substr(valueSql, 1);
        }
        
        return this->executeSql(sql, param);
    }
}

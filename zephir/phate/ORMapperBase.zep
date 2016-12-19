namespace Phate;

class ORMapperBase
{
    protected tableName;
    
    protected pkey = [];
    
    protected pkeyIsRowId = false;
    
    protected value = [];
    
    protected type = [];
    
    protected toSave = [];
    
    protected changeFlg = true;
    
    protected fromHydrateFlg = false;

    /**
     * 行配列をオブジェクトに設定する
     **/
    public function hydrate(array row) -> void
    {
        var column;
        let this->changeFlg = false;
        let this->fromHydrateFlg = true;
        for column in array_keys(this->value) {
            if (array_key_exists(column, row)) {
                let this->value[column] = row[column];
                let this->toSave[column] = row[column];
            }
        }
    }

    /**
     * オブジェクトのプロパティを行配列の形にする
     **/
    public function toArray() -> array
    {
        return this->toSave;
    }

    /**
     * オブジェクトの状態をDBサーバに反映させるためにInsert/Update文を発行する
     **/
    public function save(<DBObj> dbh) -> bool
    {
        var key;
        var value;
        var sql;
        var column;
        var columns;
        var toSave;
        var columnClause;
        var placeClause;
        var setClause;
        var setParam;
        var whereClause;
        var whereParam;
        var sth;
        var i;
        // hydrate後に変更がない場合はなにもしない
        if (this->fromHydrateFlg && !this->changeFlg) {
            return false;
        }
        // special column name (date time系)
        // "modified"カラムは特別扱い
        if (array_key_exists("modified", this->toSave) && (this->toSave["modified"] === this->value["modified"])) {
            let this->toSave["modified"] = Timer::getDateTime();
        }
        // "updated"カラムは特別扱い
        if (array_key_exists("updated", this->toSave) && (this->toSave["updated"] === this->value["updated"])) {
            let this->toSave["updated"] = Timer::getDateTime();
        }
        // "updated_at"カラムは特別扱い
        if (array_key_exists("updated_at", this->toSave) && (this->toSave["updated_at"] === this->value["updated_at"])) {
            let this->toSave["updated_at"] = Timer::getDateTime();
        }
        // insertの場合
        if (!this->fromHydrateFlg) {
            // "created"カラムは特別扱い
            if (array_key_exists("created", this->toSave) && is_null(this->toSave["created"])) {
                let this->toSave["created"] = Timer::getDateTime();
            }
            // "inserted"カラムは特別扱い
            if (array_key_exists("inserted", this->toSave) && is_null(this->toSave["inserted"])) {
                let this->toSave["inserted"] = Timer::getDateTime();
            }
            // "created_at"カラムは特別扱い
            if (array_key_exists("created_at", this->toSave) && is_null(this->toSave["created_at"])) {
                let this->toSave["created_at"] = Timer::getDateTime();
            }
            // "inserted"カラムは特別扱い
            if (array_key_exists("inserted_at", this->toSave) && is_null(this->toSave["inserted_at"])) {
                let this->toSave["inserted_at"] = Timer::getDateTime();
            }
            // autoincrementに新規行を追加するとき
            let toSave = [];
            for column, value in this->toSave {
                if (column === this->pkey[0] && this->pkeyIsRowId && is_null(this->toSave[this->pkey[0]])) {
                    continue;
                }
                let toSave[column] = value;
            }
            let columns = array_keys(toSave);
            let columnClause = "(" . implode(",", columns) . ")";
            let placeClause = str_repeat("?,", count(toSave));
            let placeClause = "(" . substr(placeClause, 0, -1) . ")";
            let sql = "INSERT INTO " .this->tableName . " " . columnClause . " VALUES " . placeClause;

            let sth = dbh->prepare(sql);
            let i = 0;
            for column, value in toSave {
                let i++;
                if (array_key_exists(column, this->type)) {
                    sth->bindValue(i, value, this->type[column]);
                } else {
                    sth->bindValue(i, value, \PDO::PARAM_STR);
                }
            }
            if (sth->execute() === false) {
                return false;
            }
            if (this->pkeyIsRowId && is_null(this->toSave[this->pkey[0]])) {
                let this->toSave[this->pkey[0]] = dbh->lastInsertId();
            }
        } else {
            // updateの場合
            let setClause = "";
            let setParam = [];
            for key, value in this->toSave {
                let setClause .= setClause == "" ? " SET " : " , ";
                let setClause .= key . " = ? ";
                let setParam[key] = value;
            }
            let whereClause = "";
            let whereParam = [];
            for key in this->pkey {
                let whereClause .= whereClause == "" ? " WHERE " : " AND ";
                let whereClause .= key . " = ? ";
                let whereParam[key] = this->value[key];
            }
            let sql = "UPDATE " . this->tableName . setClause . whereClause;

            let sth = dbh->prepare(sql);
            let i = 0;
            for column, value in setParam {
                let i++;
                if (isset(this->type[column])) {
                    sth->bindValue(i, value, this->type[column]);
                } else {
                    sth->bindValue(i, value, \PDO::PARAM_STR);
                }
            }
            for column, value in whereParam {
                let i++;
                if (isset(this->type[column])) {
                    sth->bindValue(i, value, this->type[column]);
                } else {
                    sth->bindValue(i, value, \PDO::PARAM_STR);
                }
            }
            if (sth->execute() === false) {
                return false;
            }
        }
        let this->value = this->toSave;
        let this->changeFlg = false;
        let this->fromHydrateFlg = true;
        return true;
    }

    /**
     * オブジェクトに対応する行をDatabaseから削除する
     **/
    public function delete(<DBObj> dbh) -> bool
    {
        var column;
        var sth;
        var i;
        var whereClause;
        var sql;
        // hydrate済みか確認
        if (!this->fromHydrateFlg) {
            return false;
        }
        let whereClause = "";
        for column in this->pkey {
            let whereClause .= whereClause === "" ? " WHERE " : " AND ";
            let whereClause .= column . " = ?";
        }
        let sql = "DELETE FROM " . this->tableName . whereClause;
        let sth = dbh->prepare(sql);
        let i = 0;
        for column in this->pkey {
            let i++;
            if (isset(this->type[column])) {
                sth->bindValue(i, this->value[column], this->type[column]);
            } else {
                sth->bindValue(i, this->value[column], \PDO::PARAM_STR);
            }
        }
        if (sth->execute() === false) {
            return false;
        }
        let this->changeFlg = false;
        let this->fromHydrateFlg = true;
        return true;
    }



}
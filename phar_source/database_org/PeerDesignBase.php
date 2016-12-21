namespace \%%projectName%%\db;

/**
 * %%className%%Peerクラス
 *
 * %%tableName%%のO-RMapper取り扱い用クラス
 *
 * @package %%projectName%%
 * @access public
 **/
class %%className%%Peer extends \Phate\ModelBase
{
    public static function retrieveByPk(%%pkeysArg%% \Phate\DBObj $dbh = null)
    {
        if (is_null($dbh)) {
            $dbh = \Phate\Database::getInstance('%%databaseName%%');
        }
        $params = [%%pkeys%%];
        $sql = 'SELECT * FROM %%pureTableName%% WHERE %%pkeyWhere%%';
        if (($row = $dbh->getRow($sql, $params)) === false) {
            return false;
        }
        $obj = new %%className%%Orm();
        $obj->hydrate($row);
        return $obj;
    }

    public static function retrieveByPkForUpdate(%%pkeysArg%% \Phate\DBObj $dbh)
    {
        $params = [%%pkeys%%];
        $sql = 'SELECT * FROM %%pureTableName%% WHERE %%pkeyWhere%% FOR UPDATE';
        if (($row = $dbh->getRow($sql, $params)) === false) {
            return false;
        }
        $obj = new %%className%%Orm();
        $obj->hydrate($row);
        return $obj;
    }
}

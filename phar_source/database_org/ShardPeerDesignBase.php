namespace %%projectName%%\db;

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
    public static function retrieveByPk(%%pkeysArg%% $shardId = null, \Phate\DBO $dbh = null)
    {
        if (is_null($dbh)) {
            if (is_null($shardId)) {
                throw new \Phate\DatabaseException('shardId empty');
            }
            $dbh = \Phate\DB::getInstanceByShardId('%%databaseName%%', $shardId);
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

    public static function retrieveByPkForUpdate(%%pkeys%%, \Phate\DBO $dbh)
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

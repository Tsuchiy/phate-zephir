namespace %%projectName%%\db;

/**
 * %%className%%Peerクラス
 *
 * %%tableName%%のO-RMapper取り扱い用クラス(ReadOnly)
 *
 * @package %%projectName%%
 * @access public
 **/
class %%className%%Peer extends \Phate\ModelBase
{
    public static function retrieveByPk(%%pkeysArg%% $shardId)
    {
        $obj = new %%className%%Orm();
        if (is_null($shardId)) {
            throw new \Phate\DatabaseException('shardId empty');
        }
        $dbh = \Phate\Database::getInstanceByShardId('%%slaveDatabaseName%%', $shardId);
        $params = [%%pkeys%%];
        $sql = 'SELECT * FROM %%pureTableName%% WHERE %%pkeyWhere%%';
        if (($row = $dbh->getRow($sql, $params)) === false) {
            return false;
        }
        $obj->hydrate($row);
        return $obj;
    }
}

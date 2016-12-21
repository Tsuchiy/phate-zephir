namespace \%%projectName%%\db;

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

    public static function retrieveByPk(%%pkeys%%)
    {
        $obj = new %%className%%Orm();
        $dbh = \Phate\Database::getInstance('%%slaveDatabaseName%%');
        $params = [%%pkeys%%];
        $sql = 'SELECT * FROM %%pureTableName%% WHERE %%pkeyWhere%%';
        if (($row = $dbh->getRow($sql, $params)) === false) {
            return false;
        }
        $obj->hydrate($row);
        return $obj;
    }
}

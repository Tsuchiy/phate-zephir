namespace %%projectName%%\db;

/**
 * %%className%%Peerクラス
 *
 * %%tableName%%のO-RMapper取り扱い用クラス(MasterData with APCu)
 *
 * @package %%projectName%%
 * @access public
 **/
class %%className%%Peer extends \Phate\ModelBase
{
    const APCU_PREFIX_RETRIEVE_ROW = '%%className%%:row:';

    public static function retrieveByPk(%%pkeys%%)
    {
        $apcuKey = self::APCU_PREFIX_RETRIEVE_ROW . %%memkeyPkeys%%;
        $obj = new %%className%%Orm();
        if (($res = \Phate\Apcu::get($apcuKey, 'db'))) {
            $obj->hydrate($res);
            return $obj;
        }
        $dbh = \Phate\Database::getInstance('%%slaveDatabaseName%%');
        $params = [%%pkeys%%];
        $sql = 'SELECT * FROM %%pureTableName%% WHERE %%pkeyWhere%%';
        if (($row = $dbh->getRow($sql, $params)) === false) {
            return false;
        }
        \Phate\Apcu::set($apcuKey, $row, 0, 'db');
        $obj->hydrate($row);
        return $obj;
    }
}

namespace %%projectName%%\db;

/**
 * %%className%%OrmBaseクラス
 *
 * %%tableName%%のO-RMapper基礎クラス
 *
 * @package %%projectName%%
 * @access  public
 **/
class %%className%%OrmBase extends \Phate\ORMapperBase
{
    protected $tableName = '%%tableName%%';

    protected $pkey = [
%%pkey%%    ];
    protected $pkeyIsRowId = %%pkIsRowId%%;
    protected $value = [
%%value%%    ];
    protected $type = [
%%type%%    ];
    protected $toSave = [
%%value%%    ];



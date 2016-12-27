<?php
/**
 * PhatescaffoldingDatabaseクラスファイル
 *
 * @category Framework
 * @package  scafolding
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 **/
namespace Phate;

/**
 * scaffoldingDatabaseクラス
 *
 * o-rmapperのscaffolfolding機能実装クラス
 *
 * @category Framework
 * @package  scafolding
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 * @create   2014/11/13
 **/
class ScaffoldingDatabase
{
    /**
     * o-rmapper自動生成実行
     *
     * @param type $config
     */
    public function execute($config)
    {
        $projectName = $config['project_name'];
        $dbModelDirectory = CONTEXT_ROOT_DIR . 'projects/' . $projectName . '/database/';
        $peerDirectory = $dbModelDirectory . 'peer/';
        $ormDirectory = $dbModelDirectory . 'orm/';
        $ormBaseDirectory = $ormDirectory . 'ormBase/';
        FileOperate::mkdir($dbModelDirectory);
        FileOperate::mkdir($peerDirectory);
        FileOperate::mkdir($ormDirectory);
        FileOperate::mkdir($ormBaseDirectory);
        unset($config['project_name']);
        unset($config['server_env']);
        foreach ($config as $databaseName => $tmp) {
            $slaveDatabaseName = $tmp['slave_name'];
            $tableArray = $tmp['tables'];
            $isSharding = array_key_exists('sharding', $tmp) && (bool)$tmp['sharding'];
            echo "main  : " . $databaseName . " : \n";
            echo "slave : " . $slaveDatabaseName . " : \n";
            if ($isSharding) {
                echo "database constructed with sharding \n";
            }
            $dbh = \Phate\Database::getInstance($databaseName);
            foreach ($tableArray as $table) {
                // テーブル情報取得
                $tableName = $table['table_name'];
                echo $tableName . " exporting ...";
                $isMaster = false;
                $readOnly = false;
                if (array_key_exists('read_only', $table)) {
                    $readOnly = (bool)$table['read_only'];
                }
                if (array_key_exists('is_master', $table)) {
                    $isMaster = (bool)$table['is_master'];
                    $readOnly = $isMaster ? true : $readOnly;
                }
                $sql = 'SHOW COLUMNS FROM ' . $tableName;
                if (!($columnStatus = $dbh->getAll($sql))) {
                    echo 'check your yaml (table_name:' . $tableName . ")\n";
                    exit();
                }
                $className = \Phate\Common::pascalizeString($tableName);
                if (preg_match('/^.+M$/', $className)) {
                    $className = substr($className, 0, -1) . 'Master';
                }
                if (preg_match('/^.+C$/', $className)) {
                    $className = substr($className, 0, -1) . 'Control';
                }
                if (preg_match('/^.+U$/', $className)) {
                    $className = substr($className, 0, -1) . 'User';
                }
                $pkIsRowId = 'false';
                $pkeys = [];
                $pkeysCamel = [];
                $values = [];
                $types = [];
                $pkeyBindStatement = '';
                foreach ($columnStatus as $column) {
                    if (strstr($column['Extra'], 'auto_increment') !== false) {
                        $pkIsRowId = 'true';
                    }
                    if (strstr($column['Key'], 'PRI') !== false) {
                        $pkeys[] = $column['Field'];
                        $pkeysCamel[] = \Phate\Common::camelizeString($column['Field']);
                        $pkeyBindStatement .= '\'' . $column['Field'] . '\' => $' . \Phate\Common::camelizeString($column['Field']) . ', ';
                    }
                    $values[$column['Field']] = $column['Default'];
                    if ((strpos(strtolower($column['Type']), 'int') !== false)
                        || (strpos(strtolower($column['Type']), 'bit') !== false)
                        || (strpos(strtolower($column['Type']), 'float') !== false)
                        || (strpos(strtolower($column['Type']), 'double') !== false)
                        || (strpos(strtolower($column['Type']), 'decimal') !== false)) {
                        $types[$column['Field']] = '\PDO::PARAM_INT';
                    } elseif ((strpos(strtolower($column['Type']), 'binary') !== false)
                            || (strpos(strtolower($column['Type']), 'blob') !== false)) {
                        $types[$column['Field']] = '\PDO::PARAM_LOB';
                    } else {
                        $types[$column['Field']] = '\PDO::PARAM_STR';
                    }
                }
                $whereClause = implode(' = ? AND ', $pkeys) . ' = ? ';
                $pkeysList = $pkeysCamel ? '$' . implode(', $', $pkeysCamel) : '';
                $pkeysArgList = $pkeysCamel ? '$' . implode(', $', $pkeysCamel) . ',' : '';
                $memkeyPkeys = '$' . implode(" . '_' . $", $pkeysCamel);
                // ormapperBaseClass
                if (!file_exists($ormBaseDirectory . $className . 'OrmBase.class.php')) {
                    touch($ormBaseDirectory . $className . 'OrmBase.class.php');
                }
                $str = FileOperate::get('database_org/OrMapperBaseDesignBase.php');
                $str = preg_replace('/\%\%projectName\%\%/u', $projectName, $str);
                $str = preg_replace('/\%\%className\%\%/u', $className, $str);
                $str = preg_replace('/\%\%tableName\%\%/u', $tableName, $str);
                $pkeyStatement = '';
                foreach ($pkeys as $pkey) {
                    $pkeyStatement .= "        '" . $pkey . "',\n";
                }
                $str = preg_replace('/\%\%pkey\%\%/u', $pkeyStatement, $str);
                $str = preg_replace('/\%\%pkeys\%\%/u', $pkeysList, $str);
                $str = preg_replace('/\%\%pkeysArg\%\%/u', $pkeysArgList, $str);
                $str = preg_replace('/\%\%pkeyBindStatement\%\%/u', $pkeyBindStatement, $str);
                $str = preg_replace('/\%\%pkIsRowId\%\%/u', $pkIsRowId, $str);
                $str = preg_replace('/\%\%slaveDatabaseName\%\%/u', $slaveDatabaseName, $str);
                $str = preg_replace('/\%\%pureTableName\%\%/u', $tableName, $str);
                $str = preg_replace('/\%\%pkeyWhere\%\%/u', $whereClause, $str);
                $valueStatement = '';
                $methodStatement = '';
                $typeStatement = '';
                foreach ($values as $columnName => $defaultValue) {
                    $valueStatement .= "        '" . $columnName . "' => ";
                    if ((string)$defaultValue === '') {
                        $valueStatement .= "null,\n";
                    } else {
                        $valueStatement .= $types[$columnName] == '\PDO::PARAM_INT' ? $defaultValue . ",\n" : "'" . $defaultValue . "',\n";
                    }
                    
                    $methodStatement .= '    public function get' . \Phate\Common::pascalizeString($columnName) ."()\n";
                    $methodStatement .= '    {' . "\n";
                    $methodStatement .= '        return $this->toSave[\'' . $columnName . '\'];' . "\n";
                    $methodStatement .= '    }' . "\n";
                    $methodStatement .= '    ' . "\n";
                    $methodStatement .= '    public function set' . \Phate\Common::pascalizeString($columnName) .'($value)' . "\n";
                    $methodStatement .= '    {' . "\n";
                    $methodStatement .= '        if ($this->value[\'' . $columnName . '\'] != $value) {' . "\n";
                    $methodStatement .= '            $this->changeFlg = true;' . "\n";
                    $methodStatement .= '        }' . "\n";
                    $methodStatement .= '        $this->toSave[\'' . $columnName . '\'] = $value;' . "\n";
                    $methodStatement .= '    }' . "\n";
                    
                    $typeStatement .= "        '" . $columnName . "' => " .$types[$columnName] . ",\n";
                }
                $str = preg_replace('/\%\%value\%\%/u', $valueStatement, $str);
                $str = preg_replace('/\%\%type\%\%/u', $typeStatement, $str);
                if ($readOnly) {
                    $methodStatement .= '' . "\n";
                    $methodStatement .= '    public function save(\Phate\DBO $dbh)' . "\n";
                    $methodStatement .= '    {' . "\n";
                    $methodStatement .= '        throw new \Phate\DatabaseException("cant save readOnly data o/r");' . "\n";
                    $methodStatement .= '    }' . "\n\n";
                    $methodStatement .= '    public function delete(\Phate\DBO $dbh)' . "\n";
                    $methodStatement .= '    {' . "\n";
                    $methodStatement .= '        throw new \Phate\DatabaseException("cant delete readOnly data o/r");' . "\n";
                    $methodStatement .= '    }' . "\n";
                }
                
                $str = "<?php\n" . $str . $methodStatement . '}' . "\n";
                file_put_contents($ormBaseDirectory . $className . 'OrmBase.class.php', $str);
                // ormapperClass
                if (!file_exists($ormDirectory . $className . 'Orm.class.php')) {
                    $str = FileOperate::get('database_org/OrMapperDesignBase.php');
                    $str = preg_replace('/\%\%projectName\%\%/u', $projectName, $str);
                    $str = preg_replace('/\%\%className\%\%/u', $className, $str);
                    $str = preg_replace('/\%\%tableName\%\%/u', $tableName, $str);
                    $oRMapperMethod = '    // this class will be used for override';
                    $str = "<?php\n" . preg_replace('/\%\%ORMapperMethod\%\%/u', $oRMapperMethod, $str);
                    file_put_contents($ormDirectory . $className . 'Orm.class.php', $str);
                }
                // peerClass
                if (!file_exists($peerDirectory . $className . 'Peer.class.php')) {
                    if ($isSharding) {
                        if ($isMaster) {
                            $str = FileOperate::get('database_org/ShardPeerMasterDesignBase.php');
                        } elseif ($readOnly) {
                            $str = FileOperate::get('database_org/ShardPeerRODesignBase.php');
                        } else {
                            $str = FileOperate::get('database_org/ShardPeerDesignBase.php');
                        }
                    } else {
                        if ($isMaster) {
                            $str = FileOperate::get('database_org/PeerMasterDesignBase.php');
                        } elseif ($readOnly) {
                            $str = FileOperate::get('database_org/PeerRODesignBase.php');
                        } else {
                            $str = FileOperate::get('database_org/PeerDesignBase.php');
                        }
                    }
                    $str = preg_replace('/\%\%projectName\%\%/u', $projectName, $str);
                    $str = preg_replace('/\%\%tableName\%\%/u', $tableName, $str);
                    $str = preg_replace('/\%\%className\%\%/u', $className, $str);
                    $str = preg_replace('/\%\%pkeys\%\%/u', $pkeysList, $str);
                    $str = preg_replace('/\%\%pkeysArg\%\%/u', $pkeysArgList, $str);
                    $str = preg_replace('/\%\%databaseName\%\%/u', $databaseName, $str);
                    $str = preg_replace('/\%\%slaveDatabaseName\%\%/u', $slaveDatabaseName, $str);
                    $str = preg_replace('/\%\%pureTableName\%\%/u', $tableName, $str);
                    $str = preg_replace('/\%\%pkeyWhere\%\%/u', $whereClause, $str);
                    $str = preg_replace('/\%\%memkeyPkeys\%\%/u', $memkeyPkeys, $str);
                    $str = "<?php\n" . $str;
                    file_put_contents($peerDirectory . $className . 'Peer.class.php', $str);
                }
                echo " done \n";
            }
        }
    }
}

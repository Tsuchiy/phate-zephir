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
 * DBクラス
 *
 * 設定ファイルを元にDBへの接続済みのDBOを作成するクラス
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 * @create   2016/12/23
 **/
class Database
{

    /**
     * 接続名のDBObjインスタンスを返す
     *
     * @param string $dbNameSpace
     *
     * @return DBObj
     **/
    public static function getInstance(string $dbNameSpace);

    /**
     * ShardのDBObjを取得
     *
     * @param string $dbNameSpace
     * @param int    $shardId
     *
     * @return DBObj
     */
    public static function getInstanceByShardId(string $dbNameSpace, int $shardId);

    /**
     * Shardの分割数を取得
     *
     * @param string $dbNameSpace
     *
     * @return int
     */
    public static function getNumberOfShard(string $dbNameSpace);
}

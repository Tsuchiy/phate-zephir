<?php
/**
 * PhateORMapperBaseクラスファイル
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 **/
namespace Phate;

/**
 * ORMapperBaseクラス
 *
 * O-RMapperの先祖クラス。基礎パラメータと基礎メソッド群。
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 * @create   2016/12/23
 **/
class ORMapperBase
{
    /**
     * 行配列をオブジェクトに設定する
     *
     * @param array
     *
     * @return void
     **/
    public function hydrate(array $row);

    /**
     * オブジェクトのプロパティを行配列の形にする
     *
     * @return array
     **/
    public function toArray();

    /**
     * オブジェクトの状態をDBサーバに反映させるためにInsert/Update文を発行する
     *
     * @param DBObj $dbh
     *
     * @return bool
     **/
    public function save(DBObj $dbh);

    /**
     * オブジェクトに対応する行をDatabaseから削除する
     *
     * @param DBObj $dbh
     *
     * @return bool
     **/
    public function delete(DBObj $dbh);
}

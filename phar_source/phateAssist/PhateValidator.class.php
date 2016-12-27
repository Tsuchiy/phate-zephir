<?php
/**
 * PhateValidatorクラスファイル
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 **/
namespace Phate;

/**
 * Validatorクラス
 *
 * 値検証用のクラス
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 * @create   2014/11/13
 **/
abstract class Validator
{
    /*
        'noblank'          // 必須項目
        'number'           // 数字項目
        'numberminmax'     // 数字項目（上限下限）
        'alphabet'         // アルファベットのみ
        'alphabetornumber' // 英数アルファベットのみ
        'lenminmax'        // byte数（上限下限）
        'widthminmax'      // 文字数（上限下限）
        'bool'             // ブーリアンか
        'enum'             // 配列列挙にマッチするか
        'array'            // 配列
        'notarray'         // 配列以外
        'arraycountminmax' // 配列の大きさ（上限下限）
        'preg'             // preg_match
        'mbEreg'           // mb_ereg_match
    */

    /**
     * シングルトン生成
     *
     * @return Validator
     **/
    abstract public static function getInstance();

    /**
     * Validatorにルールをセット
     *
     * @param string $paramName     パラメータ名
     * @param string $validatorName validator名
     * @param array  $param         (範囲指定・具体的なデータ等)
     * @param bool   $isChain       違反時処理継続するか
     *
     * @return Validator
     **/
    abstract public function setValidator(
        string $paramName,
        string $validatorName,
        array $param = [],
        bool $isChain = false
    );

    /**
     * Validatorを実行
     *
     * @return array 結果セット
     **/
    abstract public function execute();
}


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
class Validator
{

    // Validate type
    const NO_BLANK = "typeNoBlank";                         // 必須項目
    const IS_NUMBER = "typeNumber";                         // 数字項目
    const IS_NUMBER_MIN_MAX = "typeNumberMinMax";           // 数字項目（上限下限）
    const IS_ALPHABET = "typeAlphabet";                     // アルファベットのみ
    const IS_ALPHABET_OR_NUMBER = "typeAlphabetOrNumber";   // 英数アルファベットのみ
    const LEN_MIN_MAX =  "typeLenMinMax";                   // byte数（上限下限）
    const WIDTH_MIN_MAX = "typeWidthMinMax";                // 文字数（上限下限）
    const IS_BOOL = "typeBool";                             // ブーリアンか
    const IN_ENUM = "typeEnum";                             // 配列列挙にマッチするか
    const IS_ARRAY = "typeArray";                           // 配列
    const IS_NOT_ARRAY = "typeNotArray";                    // 配列以外
    const ARRAY_COUNT_MIN_MAX = "typeArrayCountMinMax";     // 配列の大きさ（上限下限）
    const PREG_MATCH = "typePreg";                          // preg_match
    const MBEREG_MATCH = "typeMbEreg";                      // mb_ereg_match

    /**
     * シングルトン生成
     *
     * @return Validator
     **/
    public static function getInstance();

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
    public function setValidator(
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
    public function execute();
}

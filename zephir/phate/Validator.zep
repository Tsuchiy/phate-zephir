namespace Phate;

class Validator
{

    private static instance = null;

    private validatorList  = [];
    private registeredValidators = [];
    private resultValidation = [];

    /**
     * コンストラクタ
     **/
    private function __construct()
    {
        let this->validatorList = [
            "noblank"          : "typeNoBlank",           // 必須項目
            "number"           : "typeNumber",            // 数字項目
            "numberminmax"     : "typeNumberMinMax",      // 数字項目（上限下限）
            "alphabet"         : "typeAlphabet",          // アルファベットのみ
            "alphabetornumber" : "typeAlphabetOrNumber",  // 英数アルファベットのみ
            "lenminmax"        : "typeLenMinMax",         // byte数（上限下限）
            "widthminmax"      : "typeWidthMinMax",       // 文字数（上限下限）
            "bool"             : "typeBool",              // ブーリアンか
            "enum"             : "typeEnum",              // 配列列挙にマッチするか
            "array"            : "typeArray",             // 配列
            "notarray"         : "typeNotArray",          // 配列以外
            "arraycountminmax" : "typeArrayCountMinMax",  // 配列の大きさ（上限下限）
            "preg"             : "typePreg",              // preg_match
            "mbEreg"           : "typeMbEreg"            // mb_ereg_match
        ];
    }
    
    /**
     * シングルトン生成
     **/
    public static function getInstance() -> <Validator>
    {
        if (is_null(self::instance)) {
            let self::instance = new Validator();
        }
        return self::instance;
    }

    /**
     * Validatorにルールをセット
     */
    public function setValidator(string paramName, string validatorName, array param = [], bool isChain = false) -> <Validator>
    {
        if (!in_array(validatorName, array_keys(this->validatorList))) {
            throw new Exception("validator error");
        }
        if (!array_key_exists(paramName, this->registeredValidators)) {
            let this->registeredValidators[paramName] = [];
        }
        let this->registeredValidators[paramName][] = ["name" : validatorName, "param" : param, "isChain" : isChain];
        return this;
    }

    /**
     * Validatorを実行
     **/
    public function execute() -> array
    {
        var result;
        var requestParam;
        var func;
        var paramName;
        var validationArray;
        var validation;
        for paramName, validationArray in this->registeredValidators {
            let result = true;
            let requestParam = Request::getRequestParam(paramName) === "" ? null : Request::getRequestParam(paramName);
            for validation in validationArray {
                if (!result && !validation["isChain"]) {
                    break;
                }
                let func = this->validatorList[validation["name"]];
                let result = this->{func}(requestParam, validation["param"]);
                let this->resultValidation[paramName][] = ["name" : validation["name"], "param" : validation["param"], "result" : result];
            }
        }
        return this->resultValidation;
    }

    /**
     * 空白(null)は許さない
     **/
    protected function typeNoBlank(var requestParam, var validationParam) -> bool
    {
        if (is_null(requestParam)) {
            return false;
        }
        if (is_string(requestParam) && (requestParam === "")) {
            return false;
        }
        return true;
    }

    /**
     * 数字のみ許す
     **/
    protected function typeNumber(var requestParam, var validationParam) -> bool
    {
        if (is_null(requestParam)) {
            return true;
        }
        return is_numeric(requestParam);
    }

    /**
     * 数値、ある数字以上ある数字以下
     **/
    protected function typeNumberMinMax(var requestParam, array validationParam) -> bool
    {
        var min;
        var max;
        if (is_null(requestParam)) {
            return true;
        }
        if (!is_numeric(requestParam)) {
            return false;
        }
        if (!is_array(validationParam) || (count(validationParam) != 2)) {
            return false;
        }
        let min = array_shift(validationParam);
        if (!is_numeric(min)) {
            return false;
        }
        let max = array_shift(validationParam);
        if (!is_numeric(max)) {
            return false;
        }
        if ((min > requestParam) || (max < requestParam)) {
            return false;
        }
        return true;
    }

    /**
     * アルファベットのみ
     **/
    protected function typeAlphabet(var requestParam, var validationParam) -> bool
    {
        if (is_null(requestParam)) {
            return true;
        }
        if (!is_string(requestParam)) {
            return false;
        }
        return ctype_alpha(requestParam);
    }

    /**
     * アルファベットか数字によって構成された文字列
     **/
    protected function typeAlphabetOrNumber(var requestParam, var validationParam) -> bool
    {
        if (is_null(requestParam)) {
            return true;
        }
        if (!is_string(requestParam)) {
            return false;
        }
        return ctype_alnum(requestParam);
    }

    /**
     * バイト数の長さをチェック
     **/
    protected function typeLenMinMax(var requestParam, var validationParam) -> bool
    {
        var min;
        var max;
        if (is_null(requestParam)) {
            return true;
        }
        if (!is_string(requestParam)) {
            return false;
        }
        if (strlen(requestParam) == 0) {
            return true;
        }
        if (!is_array(validationParam) || (count($validationParam) != 2)) {
            return false;
        }
        let min = array_shift(validationParam);
        let max = array_shift(validationParam);
        if (!is_numeric(min)) {
            return false;
        }
        if (!is_numeric(max)) {
            return false;
        }
        if ((min > strlen(requestParam)) || (max < strlen(requestParam))) {
            return false;
        }
        return true;
    }

    /**
     * 文字数の長さチェック（全角も一文字）
     **/
    protected function typeWidthMinMax(var requestParam, var validationParam) -> bool
    {
        var min;
        var max;
        if (is_null(requestParam)) {
            return true;
        }
        if (!is_string(requestParam)) {
            return false;
        }
        if (strlen(requestParam) == 0) {
            return true;
        }
        if (!is_array(validationParam) || (count(validationParam) != 2)) {
            return false;
        }
        let min = array_shift(validationParam);
        let max = array_shift(validationParam);
        if (!is_numeric(min)) {
            return false;
        }
        if (!is_numeric(max)) {
            return false;
        }
        if ((min > mb_strlen(requestParam)) || (max < mb_strlen(requestParam))) {
            return false;
        }
        return true;
    }

    /**
     * 入力されたものが指定された配列の要素か
     **/
    protected function typeEnum(var requestParam, array validationParam) -> bool
    {
        if (is_null(requestParam)) {
            return true;
        }
        if (!is_array(validationParam)) {
            return false;
        }
        return in_array(requestParam, validationParam);
    }

    /**
     * 入力されたものがbooleanか
     **/
    protected function typeBool(var requestParam, var validationParam) -> bool
    {
        if (is_null(requestParam)) {
            return true;
        }
        return is_bool(requestParam);
    }

    /**
     * 配列か
     **/
    protected function typeArray(var requestParam, var validationParam) -> bool
    {
        if (is_null(requestParam)) {
            return true;
        }
        return is_array(requestParam);
    }
    
    /**
     * 配列ではないか
     **/
    protected function typeNotArray(var requestParam, var validationParam) -> bool
    {
        if (is_null(requestParam)) {
            return true;
        }
        return !is_array(requestParam);
    }

    /**
     * 配列の要素数が範囲内か
     **/
    protected function typeArrayCountMinMax(var requestParam, array validationParam) -> bool
    {
        var min;
        var max;
        var cnt;
        if (is_null(requestParam)) {
            return true;
        }
        if (!is_array(requestParam)) {
            return false;
        }
        if (!is_array(validationParam) || (count(validationParam) != 2)) {
            return false;
        }
        let min = array_shift(validationParam);
        let max = array_shift(validationParam);
        if (!is_numeric(min)) {
            return false;
        }
        if (!is_numeric(max)) {
            return false;
        }
        let cnt = count(requestParam);
        if ((min > cnt) || (max < cnt)) {
            return false;
        }
        return true;
    }
    /**
     * 正規表現にマッチするか
     **/
    protected function typePreg(var requestParam, string validationParam) -> bool
    {
        if (is_null(requestParam)) {
            return true;
        }
        if (!is_string(requestParam) || !is_string(validationParam)) {
            return false;
        }
        return preg_match(validationParam, requestParam) !== false;
    }
    
    /**
     * 全角使用正規表現にマッチするか
     **/
    protected function typeMbEreg(var requestParam, string validationParam) -> bool
    {
        if (is_null(requestParam)) {
            return true;
        }
        if (!is_string(requestParam) || !is_string(validationParam)) {
            return false;
        }
        return mb_ereg(validationParam, requestParam) !== false;
    }
}

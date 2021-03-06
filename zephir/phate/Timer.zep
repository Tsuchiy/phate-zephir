namespace Phate;

class Timer
{
    const DEFAULT_TIMEZONE = "Asia/Tokyo";
    const DEFAULT_RESET_TIME = "00:00:00";

    private static instance = null;

    private now;
    private mnow;
    private timezone;
    private applicationResetTime;
    
    public static function init()
    {
        if (is_null(self::instance)) {
            let self::instance = new Timer();
        }
    }

    private function __construct()
    {
        var timeStamp;
        var sysConfig;
        let timeStamp = microtime(true);
        let this->now = array_key_exists("REQUEST_TIME", _SERVER) ? _SERVER["REQUEST_TIME"] : floor(timeStamp);
        let this->mnow = array_key_exists("REQUEST_TIME_FLOAT", _SERVER) ? _SERVER["REQUEST_TIME_FLOAT"] : timeStamp;

        let sysConfig = Core::getConfigure("timer");
        let this->timezone =  array_key_exists("timezone", sysConfig) ? new \DateTimeZone(sysConfig["timezone"]) : new \DateTimeZone(self::DEFAULT_TIMEZONE);
        let this->applicationResetTime = array_key_exists("application_reset_time", sysConfig) ? sysConfig["application_reset_time"] : self::DEFAULT_RESET_TIME;
        ini_set("date.timezone", this->timezone->getName());
        
    }

    /**
     * TimeZone設定済みDateTimeクラスを取得する
     */
    private static function getDateTimeClass(int timestamp = null) -> <\DateTime>
    {
        var ts;
        var dt;
        let ts = timestamp == 0 ? self::instance->now : timestamp;

        if (is_int(ts)) {
            let dt = \DateTime::createFromFormat("U", ts);
        } else {
            let dt = \DateTime::createFromFormat("U.u", sprintf("%6F", ts));
        }
        dt->setTimeZone(self::instance->timezone);
        return dt;

    }

    /**
     * TimeZone設定済みDateTimeクラスを取得する
     */
    private static function getDateTimeClassByString(string str = null) -> <\DateTime>
    {
        if (str === "") {
            return self::getDateTimeClass();
        }
        var arr;
        let arr = [];
        if (preg_match("/^([0-9]+)\-([0-9]+)\-([0-9]+)\s([0-9]+):([0-9]+):([0-9]+)$/", str, arr)) {
            let arr[6] = "000000";
        } elseif (preg_match("/^([0-9]+)\-([0-9]+)\-([0-9]+)\s([0-9]+):([0-9]+):([0-9]+)\.([0-9]+)$/", str, arr)) {
            let arr[6] = str_pad(arr[6], 6, "0", STR_PAD_RIGHT);
        } else {
            return self::getDateTimeClass();
        }
        return \DateTime::createFromFormat(
            "Y-m-d H:i:s.u",
            sprintf("%04d-%02d-%02d %02d:%02d:%02d.%6s", arr[0], arr[1], arr[2], arr[3], arr[4], arr[5], arr[6]),
            self::instance->timezone
        );
    }

    /**
     * 生成時のUnixTimeStampを得る
     */
    public static function getUnixTimeStamp(string dateString = null) -> int
    {
        return self::getDateTimeClassByString(dateString)->getTimestamp();
    }

    /**
     * 生成時のUnixTimeStampをマイクロ秒単位で得る
     */
    public static function getMicroTimeStamp(string dateString = null) -> float
    {
        if (dateString === "") {
            return self::instance->mnow;
        }
        var datetimeClass;
        let datetimeClass = self::getDateTimeClassByString(dateString);
        return floatval(datetimeClass->format("U.u"));
    }

    /**
     * フォーマットされた日時を得る
     */
    public static function getDateTime(int timestamp = null) -> string
    {
        return self::format("Y-m-d H:i:s", timestamp);
    }

    /**
     * フォーマットされた時刻を得る
     */
    public static function getTimeFormat(int timestamp = null) -> string
    {
        return self::format("H:i:s", timestamp);
    }

    /**
     * フォーマットされた日を得る
     */
    public static function getDateFormat(int timestamp = null) -> string
    {
        return self::format("Y-m-d", timestamp);
    }

    /**
     * 曜日を得る
     */
    public static function getWeekDate(int timestamp = null) -> int
    {
        return intval(self::format("w", timestamp));
    }

    /**
     * DateTimeフォーマットに従った文字列を返す
     */
    public static function format(string format, int timestamp = null) -> string
    {
        return self::getDateTimeClass(timestamp)->format(format);
    }

    /**
     * アプリ内リセット時間を考慮したフォーマットされた日を得る
     */
    public static function getApplicationDate(int timestamp = null) -> string
    {
        var datetimeClass;
        let datetimeClass = self::getDateTimeClass(timestamp);
        if (datetimeClass->format("H:i:s", timestamp) < self::instance->applicationResetTime) {
            datetimeClass->add(new \DateInterval("P-1D"));
        }
        return $datetimeClass->format("Y-m-d", timestamp);
    }

    /**
     * String形式の日付の間隔を取得する
     */
    public static function getDateTimeDiff(string toTimeString, string fromTimeString = null) -> array
    {
        var timeAmount;
        var rtn;
        let rtn = [
            "day"    : 0,
            "hour"   : 0,
            "minute" : 0,
            "second" : 0
        ];
        let timeAmount = self::getDateTimeDiffSecond(toTimeString, fromTimeString);
        let rtn["second"] = timeAmount % 60;
        let timeAmount = floor(timeAmount / 60);
        let rtn["minute"] = timeAmount % 60;
        let timeAmount = floor(timeAmount / 60);
        let rtn["hour"] = timeAmount % 24;
        let timeAmount = floor(timeAmount / 24);
        let rtn["day"] = timeAmount;
        return rtn;
    }

    /**
     * String形式の日付の間隔を秒単位で取得する
     */
    public static function getDateTimeDiffSecond(string toTimeString, string fromTimeString = null) -> int
    {
        return self::getUnixTimestamp(toTimeString) - self::getUnixTimestamp(fromTimeString);
    }

    /**
     * 現在時刻をセットする（主に仮想時刻用）
     */
    private function setTimeStampInstance(int unixtimestamp) -> void
    {
        let this->now = unixtimestamp;
        let this->mow = unixtimestamp;
    }
    public static function setTimeStamp(int unixtimestamp) -> void
    {
        self::instance->setTimeStampInstance(unixtimestamp);
    }
}

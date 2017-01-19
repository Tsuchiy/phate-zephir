
/**
 * PhateTimerクラスファイル
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 **/
namespace Phate;

/**
 * Timerクラス
 *
 * 実行開始時刻の記録・取得と、時間に対する各メソッド群
 *
 * @category Framework
 * @package  BaseLibrary
 * @access   public
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 * @create   2016/12/23
 **/
class Timer
{
    /**
     * 生成時のUnixTimeStampを得る
     *
     * @param string $dateString
     *
     * @return int
     */
    public static function getUnixTimeStamp(string $dateString = null);

    /**
     * 生成時のUnixTimeStampをマイクロ秒単位で得る
     *
     * @param string $dateString
     *
     * @return float
     */
    public static function getMicroTimeStamp(string $dateString = null);

    /**
     * フォーマットされた日時を得る
     *
     * @param int $timestamp
     *
     * @return string
     */
    public static function getDateTime(int $timestamp = null);

    /**
     * フォーマットされた時刻を得る
     *
     * @param int $timestamp
     *
     * @return string
     */
    public static function getTimeFormat(int $timestamp = null);

    /**
     * フォーマットされた日を得る
     *
     * @param int $timestamp
     *
     * @return string
     */
    public static function getDateFormat(int $timestamp = null);

    /**
     * 曜日を得る
     *
     * @param int $timestamp
     *
     * @return int
     */
    public static function getWeekDate(int $timestamp = null);

    /**
     * DateTimeフォーマットに従った文字列を返す
     *
     * @param string $format
     * @param int    $timestamp
     *
     * @return string
     */
    public static function format(string $format, int $timestamp = null);

    /**
     * アプリ内リセット時間を考慮したフォーマットされた日を得る
     *
     * @param int $timestamp
     *
     * @return string
     */
    public static function getApplicationDate(int $timestamp = null);

    /**
     * String形式の日付の間隔を取得する
     *
     * @param string $toTimeString
     * @param string $fromTimeString
     *
     * @return array ["day" => 0,"hour" => 0,"minute" => 0,"second" => 0]形式
     */
    public static function getDateTimeDiff(string $toTimeString, string $fromTimeString = null);

    /**
     * String形式の日付の間隔を秒単位で取得する
     *
     * @param string $toTimeString
     * @param string $fromTimeString
     *
     * @return int
     */
    public static function getDateTimeDiffSecond(string $toTimeString, string $fromTimeString = null);

    /**
     * 現在時刻をセットする（主に仮想時刻用）
     *
     * @param int $unixtimestamp
     *
     * @return void
     */
    public static function setTimeStamp(int $unixtimestamp);
}

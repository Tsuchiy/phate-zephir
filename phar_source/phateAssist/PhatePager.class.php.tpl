
/**
 * PhatePagerクラスファイル
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 **/
namespace Phate;

/**
 * Pagerクラス
 *
 * ページャ処理クラス
 *
 * @category Framework
 * @package  BaseLibrary
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 * @create   2016/12/23
 **/
class Pager
{
    /**
     * コンストラクタ
     *
     * @param array $items
     *
     * @return Pager
     */
    public function __construct(array $items);
    
    /**
     * 1ページあたりの件数を設定する
     *
     * @param int $pageSize
     *
     * @return void
     */
    public function setPageSize(int $pageSize);

    /**
     * 最初のページ番号を取得する
     *
     * @return int
     */
    public function getFirstPage();

    /**
     * 最後のページ数を取得する
     *
     * @return int
     */
    public function getLastPage();
    
    /**
     * ページのデータを抽出する
     *
     * @param int $pageNo
     *
     * @return array
     */
    public function getPageData(int $pageNo = null);

    /**
     * 現在のページ番号を設定
     *
     * @param int $pageNo
     *
     * @return void
     */
    public function setNowPage(int $pageNo);

    /**
     * 現在のページ番号を取得する
     *
     * @return int
     */
    public function getNowPage();

    /**
     * 現在の次のページ番号を取得する
     *
     * @return int
     */
    public function getNextPage();

    /**
     * 現在の前のページ番号を取得する
     *
     * @return int
     */
    public function getPrevPage();
    
    /**
     * 総アイテム数を返す
     *
     * @return int
     */
    public function getAllCount();
}

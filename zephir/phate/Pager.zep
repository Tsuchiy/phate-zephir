namespace Phate;

class Pager
{
    protected items = [];
    protected pageSize = 10;
    protected nowPage = 1;
    
    /**
     * コンストラクタ
     */
    public function __construct(array items) -> void
    {
        let this->items = items;
    }
    
    /**
     * 1ページあたりの件数を設定する
     */
    public function setPageSize(int pageSize) -> void
    {
        let this->pageSize = pageSize;
    }
    
    /**
     * 最初のページ番号を取得する
     */
    public function getFirstPage() -> int
    {
        return count(this->items) ? 1 : 0;
    }
    
    /**
     * 最後のページ数を取得する
     */
    public function getLastPage() -> int
    {
        return count(this->items) ? ceil(count(this->items) / this->pageSize) : 0;
    }
    
    /**
     * ページのデータを抽出する
     */
    public function getPageData(int pageNo = null) -> array
    {
        var rtn;
        if (is_null(pageNo) || pageNo === 0) {
            let pageNo = intval(this->nowPage);
        } else {
            let this->nowPage = pageNo;
        }

        let rtn = [];
        if (pageNo <= 0) {
            return rtn;
        }
        var i;
        var k;
        var v;
        let i = 0;
        for k, v in this->items {
            let i++;
            if (ceil(i / this->pageSize) == pageNo) {
                let rtn[k] = v;
            } elseif (ceil(i / this->pageSize) > pageNo) {
                break;
            }
        }
        return rtn;
    }
    
    /**
     * 現在のページ番号を設定
     */
    public function setNowPage(int pageNo) -> void
    {
        if (pageNo < this->getFirstPage()) {
            throw new Exception("illegal page number");
        }
        if (pageNo > this->getLastPage()) {
            let this->nowPage = this->getLastPage();
            return;
        }
        let this->nowPage = pageNo;
    }

    /**
     * 現在のページ番号を取得する
     */
    public function getNowPage() -> int
    {
        return count(this->items) ? this->nowPage : 0;
    }

    /**
     * 現在の次のページ番号を取得する
     */
    public function getNextPage() -> int
    {
        if ((this->getNowPage() + 1) > this->getLastPage()) {
            return 0;
        }
        return this->getNowPage() + 1;
    }
    
    /**
     * 現在の前のページ番号を取得する
     */
    public function getPrevPage() -> int
    {
        if (this->getNowPage() <= 1) {
            return 0;
        }
        return this->getNowPage() - 1;
    }
    
    /**
     * 総アイテム数を返す
     */
    public function getAllCount() -> int
    {
        return count(this->items);
    }
}

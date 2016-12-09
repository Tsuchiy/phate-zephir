namespace Phate;

class Pager
{
    protected items = [];
    protected pageSize = 10;
    protected nowPage = 1;
    
    /**
     * コンストラクタ
     */
    public function __construct(array items)
    {
        let this->items = items;
    }
    
    /**
     * 1ページあたりの件数を設定する
     */
    public function setPageSize(int pageSize)
    {
        let this->pageSize = pageSize;
    }
    
    /**
     * 最初のページ番号を取得する
     */
    public function getFirstPage()
    {
        return count(this->items) ? 1 : 0;
    }
    
    /**
     * 最後のページ数を取得する
     */
    public function getLastPage()
    {
        return count(this->items) ? ceil(count(this->items) / this->pageSize) : 0;
    }
    
    /**
     * ページのデータを抽出する
     */
    public function getPageData(int pageNo = null)
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
    public function setNowPage(int pageNo)
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
    public function getNowPage()
    {
        return count(this->items) ? this->nowPage : 0;
    }

    /**
     * 現在の次のページ番号を取得する
     */
    public function getNextPage()
    {
        if ((this->getNowPage() + 1) > this->getLastPage()) {
            return 0;
        }
        return this->getNowPage() + 1;
    }
    
    /**
     * 現在の前のページ番号を取得する
     */
    public function getPrevPage()
    {
        if (this->getNowPage() <= 1) {
            return 0;
        }
        return this->getNowPage() - 1;
    }
    
    /**
     * 総アイテム数を返す
     */
    public function getAllCount()
    {
        return count(this->items);
    }
}

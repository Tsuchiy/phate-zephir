<?php

class TestHttpRequester
{
    const HTTP_STATUS_OK = 200;

    protected $_urlBase = '';

    public $rtnStatus;
    public $rtnHeader;
    public $rtnBody;

    public function __construct()
    {
        $urlConfig = \Phate\Core::getConfigure('base_uri');
        if (strpos($urlConfig, ':') === false || strpos($urlConfig, ':') > strpos($urlConfig, '.')) {
            $urlConfig = "http://" . $urlConfig;
        }
        $this->_urlBase = $urlConfig;
    }

    public function setUrlBase($urlBase)
    {
        $this->_urlBase = $urlBase;
    }

    public function setPassword($password)
    {
        $this->_password = $password;
    }

    /**
     * Httpリクエスト
     *
     * @access public
     * @param  string $url
     * @param  mixed $post
     * @return void
     */
    public function access($url, $headers = [], $post = [])
    {
        //
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HEADER, true);
        // header
        $headers = array_merge(
            [
            ],
            $headers
        );
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        //url
        $url = $this->_urlBase . $url;
        curl_setopt($ch, CURLOPT_URL, $url);
        // post
        $postField = '';
        if ($post) {
            if (is_array($post)) {
                /** normal post */
                foreach ($post as $k => $v) {
                    $postField .= urlencode($k) . '=' . urlencode($v) . '&';
                }
                $postField = substr($postField, 0, -1);
            } else {
                /** bytes post **/
                $postField = $post;
            }
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, $postField);
        }
        // URL を取得する
        $r = curl_exec($ch);
        $this->rtnStatus = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $rtnHeaderSize = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
        // cURL リソースを閉じる
        curl_close($ch);
        $this->rtnHeader = substr($r, 0, $rtnHeaderSize);
        $this->rtnBody = substr($r, $rtnHeaderSize);
        if ($this->rtnStatus != self::HTTP_STATUS_OK) {
            return false;
        }
        return true;
    }
}

<?php
namespace Phate;

/**
 * NginxConfigクラス
 *
 * 必要ディレクトリ準備実装クラス
 *
 * @package PhateFramework scaffolding
 * @access  public
 * @author  Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @create  2016/12/21
 **/
class NginxConfig
{
    /**
     * 必要なディレクトリを作成
     *
     * return void
     */
    public function show($projectName)
    {
        $str = FileOperate::get("nginx_org/nginx_conf.php");
        $str = str_replace('%%projectName%%', $projectName, $str);
        $str = str_replace('%%contextRoot%%', CONTEXT_ROOT_DIR, $str);

        echo $str;
    }
    
}

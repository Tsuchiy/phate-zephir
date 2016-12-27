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
        $str = preg_replace('/\%\%projectName\%\%/u', $projectName, $str);
        $str = preg_replace('/\%\%contextRoot\%\%/u', CONTEXT_ROOT_DIR, $str);

        echo $str;
    }
    
}

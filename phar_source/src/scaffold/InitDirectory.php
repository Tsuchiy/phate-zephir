<?php
namespace Phate;

/**
 * InitDirectoryクラス
 *
 * 必要ディレクトリ準備実装クラス
 *
 * @package PhateFramework scaffolding
 * @access  public
 * @author  Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @create  2016/12/21
 **/
class InitDirectory
{
    /**
     * 必要なディレクトリを作成
     *
     * return void
     */
    public function execute()
    {
        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'cache', true);
        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'configs');
        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'htdocs');
        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'logs', true);
        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'projects');
        if (!file_exists(CONTEXT_ROOT_DIR . '.gitignore')) {
            file_put_contents(CONTEXT_ROOT_DIR . '.gitignore', FileOperate::get("init_org/gitignore_org.php"));
        }
    }
    
}

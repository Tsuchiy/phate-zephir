<?php
namespace Phate;

/**
 * scaffoldingTestクラス
 *
 * testのscaffolfolding機能実装クラス
 *
 * @package PhateFramework scaffolding
 * @access  public
 * @author  Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @create  2016/12/23
 **/
class ScaffoldingTest
{
    /**
     * scaffolding実行
     *
     * @param string $projectName プロジェクト名
     * @param string $projectName 環境変数
     *
     * @return void;
     */
    public function execute($projectName, $serverEnv)
    {
        // put dispatcher
        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'tests/');
        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'tests/' . $projectName);
        $filename = 'tests/' . $projectName . '/phpunit.xml';
        if (!file_exists($filename)) {
            $str = FileOperate::get('test_org/phpunit.xml');
            file_put_contents($filename, $str);
        }
        $filename = 'tests/' . $projectName . '/bootstrap.php';
        if (!file_exists($filename)) {
            $str = FileOperate::get('test_org/bootstrap.php.tpl');
            $str = preg_replace('/\%\%projectName\%\%/u', $projectName, $str);
            $str = preg_replace('/\%\%serverEnv\%\%/u', $serverEnv, $str);
            file_put_contents($filename, '<?php' . $str);
        }
        $filename = 'tests/' . $projectName . '/TestHttpRequester.php';
        if (!file_exists($filename)) {
            $str = FileOperate::get('test_org/TestHttpRequester.php.tpl');
            file_put_contents($filename, '<?php' . $str);
        }
        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'tests/' . $projectName . '/controllers');
        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'tests/' . $projectName . '/controllers/index');
        $filename = 'tests/' . $projectName . '/controllers/index/IndexControllerTest.php';
        if (!file_exists($filename)) {
            $str = FileOperate::get('test_org/controllers/index/IndexControllerTest.php.tpl');
            file_put_contents($filename, '<?php' . $str);
        }
    }
}

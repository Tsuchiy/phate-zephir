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
class AddAssist
{
    /**
     * 必要なディレクトリを作成
     *
     * return void
     */
    public function execute()
    {
        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'phateAssist', true);
        $this->copy('PhateException.class.php.tpl');
        $this->copy('PhateNotFoundException.class.php.tpl');
        $this->copy('PhateRedirectException.class.php.tpl');
        $this->copy('PhateKillException.class.php.tpl');
        $this->copy('PhateUnauthorizedException.class.php.tpl');
        $this->copy('PhateCore.class.php.tpl');
        $this->copy('PhateCommon.class.php.tpl');
        $this->copy('PhateTimer.class.php.tpl');
        $this->copy('PhateLogger.class.php.tpl');
        $this->copy('PhateRequest.class.php.tpl');
        $this->copy('PhateResponse.class.php.tpl');
        $this->copy('PhateModelBase.class.php.tpl');
        $this->copy('PhateControllerBase.class.php.tpl');
        $this->copy('PhateExceptionHandlerBase.class.php.tpl');
        $this->copy('PhateFilterBase.class.php.tpl');
        $this->copy('PhateBatchBase.class.php.tpl');
        $this->copy('PhateDatabaseException.class.php.tpl');
        $this->copy('PhateORMapperBase.class.php.tpl');
        $this->copy('PhateDBObj.class.php.tpl');
        $this->copy('PhateDatabase.class.php.tpl');
        $this->copy('PhateFluentd.class.php.tpl');
        $this->copy('PhateValidator.class.php.tpl');
        $this->copy('PhatePager.class.php.tpl');
        $this->copy('PhatePureRenderer.class.php.tpl');
        $this->copy('PhatePhpRenderer.class.php.tpl');
        $this->copy('PhateMsgPackRenderer.class.php.tpl');
        $this->copy('PhateJsonRenderer.class.php.tpl');
        $this->copy('PhateCsvRenderer.class.php.tpl');
        $this->copy('PhateApcu.class.php.tpl');
        $this->copy('PhateRedisExceptions.class.php.tpl');
        $this->copy('PhateRedis.class.php.tpl');
        $this->copy('PhateMemcachedException.class.php.tpl');
        $this->copy('PhateMemcached.class.php.tpl');
    }
    
    private function copy($fileName)
    {
        $str = FileOperate::get('phateAssist/' . $fileName);
        file_put_contents(CONTEXT_ROOT_DIR . 'phateAssist/' . substr($fileName, 0, -4), '<?php' . $str);
    }
}

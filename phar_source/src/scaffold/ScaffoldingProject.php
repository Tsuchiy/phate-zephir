<?php
namespace Phate;

/**
 * scaffoldingProjectクラス
 *
 * projectのscaffolfolding機能実装クラス
 *
 * @package PhateFramework scaffolding
 * @access  public
 * @author  Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @create  2016/12/21
 **/
class ScaffoldingProject
{
    /**
     * scaffolding実行
     *
     * @param string $name プロジェクト名
     */
    public function execute($name)
    {
        // put dispatcher
        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'htdocs/' . $name);
        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'htdocs/' . $name . '/css');
        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'htdocs/' . $name . '/img');
        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'htdocs/' . $name . '/js');
        file_put_contents(CONTEXT_ROOT_DIR . 'htdocs/' . $name . '/robots.txt', FileOperate::get('project_org/htdocs/robots_txt.php'));
        $str = FileOperate::get('project_org/htdocs/index.php');
        $str = "<?php\n" . $this->replaceEscape($name, $str);
        file_put_contents(CONTEXT_ROOT_DIR . 'htdocs/' . $name . '/index.php', $str);

        // put config
        $fileName = CONTEXT_ROOT_DIR . 'configs/' . $name . '.yml';
        if (!file_exists($fileName)) {
            $str = $this->replaceEscape($name, FileOperate::get('project_org/configs/mainConfig_yml.php'));
            file_put_contents($fileName, $str);
        }
        $fileName = CONTEXT_ROOT_DIR . 'configs/' . $name . '_logger.yml';
        if (!file_exists($fileName)) {
            $str = $this->replaceEscape($name, FileOperate::get('project_org/configs/loggerConfig_yml.php'));
            file_put_contents($fileName, $str);
        }
        $fileName = CONTEXT_ROOT_DIR . 'configs/' . $name . '_filter.yml';
        if (!file_exists($fileName)) {
            $str = $this->replaceEscape($name, FileOperate::get('project_org/configs/filterConfig_yml.php'));
            file_put_contents($fileName, $str);
        }
        $fileName = CONTEXT_ROOT_DIR . 'configs/' . $name . '_database.yml';
        if (!file_exists($fileName)) {
            $str = $this->replaceEscape($name, FileOperate::get('project_org/configs/databaseConfig_yml.php'));
            file_put_contents($fileName, $str);
        }
        $fileName = CONTEXT_ROOT_DIR . 'configs/' . $name . '_apc.yml';
        if (!file_exists($fileName)) {
            $str = $this->replaceEscape($name, FileOperate::get('project_org/configs/apcConfig_yml.php'));
            file_put_contents($fileName, $str);
        }
        $fileName = CONTEXT_ROOT_DIR . 'configs/' . $name . '_redis.yml';
        if (!file_exists($fileName)) {
            $str = $this->replaceEscape($name, FileOperate::get('project_org/configs/redisConfig_yml.php'));
            file_put_contents($fileName, $str);
        }
        $fileName = CONTEXT_ROOT_DIR . 'configs/' . $name . '_orm.yml';
        if (!file_exists($fileName)) {
            $str = $this->replaceEscape($name, FileOperate::get('project_org/configs/ormConfig_yml.php'));
            file_put_contents($fileName, $str);
        }
        
        // make project directory
        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'projects/' . $name);

        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'projects/' . $name . '/controllers');
        $fileName = CONTEXT_ROOT_DIR . 'projects/' . $name . '/controllers/CommonController.class.php';
        $str = "<?php\n" . $this->replaceEscape($name, FileOperate::get('project_org/project/CommonController_class.php'));
        file_put_contents($fileName, $str);

        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'projects/' . $name . '/controllers/index');
        $fileName = CONTEXT_ROOT_DIR . 'projects/' . $name . '/controllers/index/IndexController.class.php';
        $str = "<?php\n" . $this->replaceEscape($name, FileOperate::get('project_org/project/IndexController_class.php'));
        file_put_contents($fileName, $str);

        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'projects/' . $name . '/models');
        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'projects/' . $name . '/views');
        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'projects/' . $name . '/database');
        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'projects/' . $name . '/database/orm');
        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'projects/' . $name . '/database/peer');

        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'projects/' . $name . '/exception');
        $fileName = CONTEXT_ROOT_DIR . 'projects/' . $name . '/exception/ExceptionHandler.class.php';
        $str = "<?php\n" . $this->replaceEscape($name, FileOperate::get('project_org/project/ExceptionHandler_class.php'));
        file_put_contents($fileName, $str);

        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'projects/' . $name . '/filters');
        $fileName = CONTEXT_ROOT_DIR . 'projects/' . $name . '/filters/MaintenanceFilter.class.php';
        $str = "<?php\n" . $this->replaceEscape($name, FileOperate::get('project_org/project/MaintenanceFilter_class.php'));
        file_put_contents($fileName, $str);

        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'projects/' . $name . '/maintenance');
        $fileName = CONTEXT_ROOT_DIR . 'projects/' . $name . '/maintenance/toRename.php';
        $str = "<?php\n" . $this->replaceEscape($name, FileOperate::get('project_org/project/MaintenanceCheck.php'));
        file_put_contents($fileName, $str);

        FileOperate::mkdir(CONTEXT_ROOT_DIR . 'projects/' . $name . '/batches');
        $fileName = CONTEXT_ROOT_DIR . 'projects/' . $name . '/batches/CommonBatch.class.php';
        $str = "<?php\n" . $this->replaceEscape($name, FileOperate::get('project_org/project/CommonBatch_class.php'));
        file_put_contents($fileName, $str);
    }
    
    private function replaceEscape($projectName, $str)
    {
        $str = str_replace('%%projectName%%', $projectName, $str);
        $str = str_replace('%%contextRoot%%', CONTEXT_ROOT_DIR, $str);
        return $str;
    }
}

#!/usr/bin/env php
<?php
namespace Phate;
// 各ディレクトリ定数宣言
define('CONTEXT_ROOT_DIR', realpath(getcwd()) . DIRECTORY_SEPARATOR);

function show_usage()
{
    echo "usage : scaffolding [command] [argument]\n";
    echo "command\n";
    echo "    help                      : show this message\n";
    echo "    project [project_name]    : make scaffolding for project\n";
    echo "    assist                    : add assist code for IDE\n";
    echo "    test [project_name] [env] : add testing base code\n";
    echo "    database [yaml file]      : make ORMappers from yaml file\n";
    echo "    nginx [project_name]      : show nginx config\n";
    echo "    version                   : show \"Phate framework\" version\n";
    echo "\n";
}

class FileOperate
{
    public static function get($fileName)
    {
        ob_start();
        require $fileName;
        $content= ob_get_contents();
        ob_end_clean();
        return $content;
    }
    
    public static function mkdir($dir, $addAuth = false)
    {
        if (!file_exists($dir)) {
            mkdir($dir);
            if ($addAuth) {
                chmod($dir, 0777);
            } else {
                chmod($dir, 0755);
            }
            touch($dir . DIRECTORY_SEPARATOR . '.gitkeep');
        }
    }
}


if (!isset($argv[1])) {
    show_usage();
    exit();
}

switch ($argv[1]) {
    case 'project':
        if (count($argv) < 3) {
            echo "error : set project name\n";
            exit(1);
        }
        
        if (file_exists(CONTEXT_ROOT_DIR . 'projects/' . $argv[2])) {
            echo "error : project already exist\n";
            exit(1);
        }
        echo "initialize for Phate frameworks\n";
        require 'src/scaffold/InitDirectory.php';
        $initDir = new InitDirectory();
        $initDir->execute();
        echo 'scaffolding project : ' . $argv[2] . "\n";
        require 'src/scaffold/ScaffoldingProject.php';
        $scaffolding = new ScaffoldingProject();
        $scaffolding->execute($argv[2]);
        echo "done. \n";
        break;
    case 'database':
        $configFile = $argv[2];
        if (!file_exists($configFile)) {
            echo "error : yaml file not exist\n";
            exit(1);
        }
        echo "scaffolding database model from " . $argv[2] . "\n";
        $config = yaml_parse_file($configFile);
        define('PROJECT_NAME', $config['project_name']);
        $instance = \Phate\Core::getInstance($config['project_name'], true, $config['server_env'], CONTEXT_ROOT_DIR);
        require 'src/scaffold/ScaffoldingDatabase.php';
        $scaffolding = new ScaffoldingDatabase();
        $scaffolding->execute($config);
        echo "all table done. \n";
        break;
    case 'nginx':
        if (count($argv) < 3) {
            echo "error : set project name\n";
            exit(1);
        }
        require 'src/scaffold/NginxConfig.php';
        $instance = new NginxConfig();
        $instance->show($argv[2]);
        break;
    case 'assist':
        echo "add php code to assist IDE. \n";
        require 'src/scaffold/AddAssist.php';
        $instance = new AddAssist();
        $instance->execute();
        echo "done. \n";
        break;
    case 'test':
        if (count($argv) < 4) {
            echo "error : set project name and server environment\n";
            exit(1);
        }
        require 'src/scaffold/ScaffoldingTest.php';
        $scaffolding = new ScaffoldingTest();
        $scaffolding->execute($argv[2], $argv[3]);
        echo "done. \n";
        break;
    case 'help':
        show_usage();
        break;
    case 'version':
        echo \Phate\Core::getVersion();
        break;
    default:
        echo "can't find command\n";
        break;
}



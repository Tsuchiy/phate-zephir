
/**
 * bootstrap
 *
 * APIテスト用基底コード
 **/
ini_set('display_errors', 1);
set_time_limit(0);
mb_internal_encoding('UTF-8');

// アプリ名
define('PROJECT_NAME', '%%projectName%%');
define('SERVER_ENV', '%%serverEnv%%');
define('BASE_DIR', realpath(dirname(__FILE__) . '/../../') . DIRECTORY_SEPARATOR);

// デバッグOnOff
$debug = true;

// Coreの読み込みしてlib周りが使えるようにする
$instance = \Phate\Core::getInstance(PROJECT_NAME, $debug, SERVER_ENV, BASE_DIR);

// 各ツールをinclude
include(realpath(dirname(__FILE__)) . '/TestHttpRequester.php');

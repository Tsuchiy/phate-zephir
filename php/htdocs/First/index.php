<?php
/**
 * PhateFrameworkディスパッチャファイル
 *
 * @category Framework
 * @package  dispatcher
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 **/
namespace Phate;

/**
 * PhateFrameworkディスパッチャ
 *
 * @category Framework
 * @package  dispatcher
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 * @create  2016/12/10
 **/
// UTF-8限定にしておく
mb_language("Ja");
mb_internal_encoding('UTF-8');

// アプリ名
define('PROJECT_NAME', 'First');

// デバッグモード取得
if (getenv('DEBUG_MODE')) {
    $debug = true;
    ini_set('display_errors', 1);
    set_time_limit(30);
    if (function_exists('xdebug_enable')) {
        ini_set('xdebug.default_enable', 1);
    }
    // opcachecode対策
    if (function_exists('opcache_invalidate')) {
        opcache_invalidate(realpath(dirname(__FILE__) . '/../..') . '/project/' . PROJECT_NAME);
    }
    // apcu対策
    if (function_exists('apcu_store')) {
        ini_set('apcu.enabled', 0);
    }
} else {
    $debug = false;
    ini_set('display_errors', 0);
    set_time_limit(0);
    if (function_exists('xdebug_enable')) {
        ini_set('xdebug.default_enable', 0);
    }
}
// サーバ環境取得
if (!($serverEnv = getenv('SERVER_ENV'))) {
    throw new Exception('Server environment is empty');
}
define('SERVER_ENV', $serverEnv);
define('BASE_DIR', realpath(dirname(__FILE__) . '/../../') . DIRECTORY_SEPARATOR);

/*
 * コード開始
 */
try {
    // Coreの読み込み
    $instance = Core::getInstance(PROJECT_NAME, $debug, SERVER_ENV, BASE_DIR);
    $instance->dispatch();
} catch (Exception $e) {
    if ($debug) {
        var_dump($e);
    }
}

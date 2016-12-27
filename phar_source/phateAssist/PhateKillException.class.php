<?php
/**
 * Phate例外クラスファイル
 *
 * @category Framework
 * @package  BaseExceptions
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 **/
namespace Phate;

/**
 * KillException例外
 *
 * 処理を中断する際の例外。exitの代わりにthrowしてください。
 *
 * @category Framework
 * @package  BaseExceptions
 * @author   Nobuo Tsuchiya <develop@m.tsuchi99.net>
 * @license  http://www.opensource.org/licenses/mit-license.html  MIT License
 * @link     https://github.com/Tsuchiy/Phate
 * @create   2014/11/13
 **/
class KillException extends Exception
{
}

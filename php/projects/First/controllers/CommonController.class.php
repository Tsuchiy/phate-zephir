<?php
namespace First;
/**
 * コントローラ基底クラス
 *
 * @package PhateFramework 
 * @access  public
 **/
class CommonController extends \Phate\ControllerBase
{
    
    public function initialize()
    {
        return true;
    }
    public function action()
    {
        return true;
    }

    public function validate()
    {
        return true;
    }

    public function validatorError(array $resultArray)
    {
        throw new \Phate\Exception('Validator Error');
    }
}

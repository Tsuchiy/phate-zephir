<?php
namespace First;
/**
 * サンプルコントローラークラス
 *
 * @project test;
 * @access  public
 **/
class IndexController extends CommonController
{
    public function action() {
        
        $renderer = new \Phate\PureRenderer();
        $renderer->render("Hello world!");
        
    }
    
}

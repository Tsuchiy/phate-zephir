namespace %%projectName%%;

/**
 * サンプルコントローラークラス
 *
 * @project %%projectName%%;
 * @access  public
 **/
class IndexController extends CommonController
{
    public function action()
    {
        $rtn = "Hello world!";
        $renderer = new \Phate\PureRenderer();
        $renderer->render($rtn);
    }
}

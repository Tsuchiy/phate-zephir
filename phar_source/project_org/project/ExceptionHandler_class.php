namespace %%projectName%%;

/**
 * ExceptionHandlerクラス
 *
 * 例外が投げられた時処理を行います
 *
 * @project %%projectName%%;
 * @access  public
 **/

class ExceptionHandler extends \Phate\ExceptionHandlerBase
{
    public function handler(\Exception $e)
    {
        if ($e instanceof \Phate\UnauthorizedException) {
            \Phate\Response::setHttpStatus(\Phate\Response::HTTP_UNAUTHORIZED);
        } else {
            \Phate\Response::setHttpStatus(\Phate\Response::HTTP_INTERNAL_SERVER_ERROR);
        }
        if (\Phate\Core::isDebug()) {
            ob_start();
            var_dump($e);
            \Phate\Response::setContentBody(ob_get_contents());
            ob_end_clean();
        }
    }
}

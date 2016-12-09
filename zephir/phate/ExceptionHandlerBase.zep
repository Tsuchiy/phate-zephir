namespace Phate;

abstract class ExceptionHandlerBase
{
    abstract public function handler(<\Exception> e) -> void;
}

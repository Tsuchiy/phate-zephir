namespace Phate;

class MsgPackRenderer
{
    public function __construct()
    {
    }
    
    public function render(var value) -> void
    {
        if (!function_exists("msgpack_serialize")) {
            throw new Exception("msgpack module not found");
        }
        Response::setContentType("application/x-msgpack");
        echo msgpack_serialize(value);
    }
}

namespace Phate;

class JsonRenderer
{
    public function __construct()
    {
    }
    
    public function render(var value) -> void
    {
        var rtn;
        let rtn =  json_encode(value);
        if (!rtn) {
            throw new Exception("cant json encode parameter");
        }
        Response::setContentType("application/json");
        echo rtn;
    }
}

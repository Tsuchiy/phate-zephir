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
            throw new Exception("parameters cant encode to json");
        }
        Response::setContentType("application/json");
        echo rtn;
    }
}

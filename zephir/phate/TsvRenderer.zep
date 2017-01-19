namespace Phate;

class TsvRenderer
{
    
    private columnNames = [];
    
    public function __construct()
    {
    }

    public function setColumnNames(array columnNameArray) -> void
    {
        let this->columnNames = columnNameArray;
    }
    
    public function render(array listArray, string filename = "") -> void
    {
        var fp;
        var row;
        var buffer;
        Response::setContentType("text/tab-separated-values");
        if (!is_null(filename)) {
            if (filename === "") {
                let filename = str_replace(" ", "_", Timer::getDateTime());
            }
            if (!preg_match("/^.*\.tsv$/", filename)) {
                let filename .= ".tsv";
            }
            Response::setHeader("Content-Disposition", "attachment; filename=\"" . filename . "\"");
        }
        ob_start();
        let fp = fopen("php://output", "w");
        if (this->columnNames) {
            fputcsv(fp, this->columnNames);
        }
        for row in listArray {
            fputcsv(fp, row);
        }
        let buffer = ob_get_contents();
        ob_end_clean();
        echo buffer;
    }
}

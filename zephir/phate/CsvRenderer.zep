namespace Phate;

class CsvRenderer
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
        Response::setContentType("text/csv");
        if (!is_null(filename)) {
            if (filename === "") {
                let filename = str_replace(" ", "_", Timer::getDateTime());
            }
            if (!preg_match("/^.*\.csv$/", filename)) {
                let filename .= ".csv";
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

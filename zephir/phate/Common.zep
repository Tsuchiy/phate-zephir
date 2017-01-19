namespace Phate;

class Common
{
    const CONTEXT_ROOT_REPLACE = "%%CONTEXT_ROOT%%";

    /**
     * サーバ環境に合わせたyamlの読み込みと配列化 with キャッシュ
     */
    public static function parseConfigYaml(string filename) -> array
    {
        var rtn;
        var serverEnv;
        let serverEnv = Core::getServerEnv();
        var apcuCacheName;
        var cacheFileName;
        // APCuキャッシュ試行
        let apcuCacheName = "PhateConfigCache:" . basename(filename) . "_" . serverEnv . ".cache";
        if (function_exists("apcu_fetch") && !Core::isDebug()) {
            let rtn = apcu_fetch(apcuCacheName);
            if (rtn) {
                return Common::unserialize(rtn);
            }
        }
        // ファイルキャッシュ試行
        let cacheFileName = Core::getCacheDir() . basename(filename) . "_" . serverEnv . ".cache";
        if (file_exists(cacheFileName) && !Core::isDebug()) {
            let rtn = Common::unserialize(file_get_contents(cacheFileName));
            if (function_exists("apcu_fetch")) {
                apcu_store(apcuCacheName, Common::serialize(rtn), 0);
            }
            return rtn;
        }
        // ファイル読み込み
        if (!file_exists(filename)) {
            throw new Exception("yaml:file not find : " . filename);
        }
        // yaml->配列化
        let rtn = [];
        var arrayTemp;
        let arrayTemp = yaml_parse(str_replace(self::CONTEXT_ROOT_REPLACE, substr(Core::getBaseDir(), 0, -1), file_get_contents(filename)));
        if (!is_array(arrayTemp)) {
            throw new Exception("yaml:illegal yaml format :" . filename);
        }
        if (array_key_exists("all", arrayTemp)) {
            let rtn = arrayTemp["all"];
        } else {
            throw new Exception("yaml:not find cardinary \"all\" :" . filename);
        }
        if (array_key_exists(serverEnv, arrayTemp)) {
            let rtn = array_merge(rtn, arrayTemp[serverEnv]);
        }
        
        // キャッシュ保存
        var serializedData;
        let serializedData = Common::serialize(rtn);
        file_put_contents(cacheFileName, serializedData, LOCK_EX);
        if (substr(sprintf("%o", fileperms(cacheFileName)), -4) !== "07" . "77") {
            chmod(cacheFileName, 0777);
        }
        if (function_exists("apcu_fetch")) {
            apcu_store(apcuCacheName, serializedData, 0);
        }
        return rtn;
    }

    /**
     * ファイル名と中身からネームスペース付きでクラス名を取得する
     */
    public static function getClassNameWithNamespace(string fileName) -> string
    {
        if (!preg_match("/^.*\.class\.php$/", fileName)) {
            return "";
        }
        var namespaceString;
        var classNameString;
        var className;
        let classNameString = substr(basename(fileName), 0, -10);
        let namespaceString = mb_strstr(file_get_contents(fileName), "namespace");

        if (namespaceString === false) {
                let className = "\\" . classNameString;
        } else {
            let namespaceString = trim(substr(namespaceString, 9, strpos(namespaceString, ";") - 9));
            if (substr(namespaceString, 0, 1) !== "\\") {
                 let namespaceString = "\\" . namespaceString;
            }
            if (substr(namespaceString, -1) !== "\\") {
                 let namespaceString = namespaceString . "\\";
            }
            let className = namespaceString . classNameString;
        }
        return className;
    }

    /**
     * 特定のパスから配下のファイルを再帰的に取得
     */
    public static function getFileNameRecursive(string path) -> array
    {
        if (is_file(path)) {
            return [path];
        }
        var rtn = [];
        var dh;
        if (is_dir(path)) {
            let dh = opendir(path);
            var file;
            loop {
                let file = readdir(dh);
                if (file === false) {
                    break;
                }
                if (file === "." || file === "..") {
                    continue;
                }
                let rtn = array_merge(rtn, self::getFileNameRecursive(path . DIRECTORY_SEPARATOR . file));
            }
            closedir(dh);
        }
        return rtn;
    }

    /**
     * snake等の文字列をpascalに置換する
     */
    public static function pascalizeString(string st) -> string
    {
        return str_replace(" " , "", 
            ucwords(
                str_replace("_", " ", 
                    strtolower(st)
                    )
                )
            );
    }

    /**
     * snake等の文字列をcamelに置換する
     */
    public static function camelizeString(string st) -> string
    {
        return lcfirst(self::pascalizeString(st));
    }

    /**
     * pascal等の文字列をsnake_caseに置換する
     */
    public static function toSnakeCaseString(string st) -> string
    {
        return strtolower(
            preg_replace("/([A-Z])/", "_$1", 
                lcfirst(st)
                )
            );
    }

    /**
     * アルゴリズムに優先を付けてシリアライズする
     */
    public static function serialize(var obj) -> string
    {
        if (function_exists("msgpack_serialize")) {
            return msgpack_serialize(obj);
        } elseif (function_exists("igbinary_serialize")) {
            return igbinary_serialize(obj);
        } elseif (function_exists("fb_serialize")) {
            return fb_serialize(obj);
        }
        return serialize(obj);
    }
    
    /**
     * アルゴリズムに優先を付けてアンシリアライズする
     */
    public static function unserialize(string st)
    {
        if (function_exists("msgpack_unserialize")) {
            return msgpack_unserialize(st);
        } elseif (function_exists("igbinary_unserialize")) {
            return igbinary_unserialize(st);
        } elseif (function_exists("fb_unserialize")) {
            var rtn = null;
            fb_unserialize(st, rtn);
            return rtn;
        }
        return unserialize(st);
    }
}

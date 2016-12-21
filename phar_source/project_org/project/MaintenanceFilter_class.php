namespace %%projectName%%;

/**
 * MaintenanceFilterクラス
 *
 * ファイルの存在からメンテナンス状態の処理を行います
 *
 * @package %%projectName%%
 * @access public
 **/
class MaintenanceFilter extends \Phate\FilterBase
{
    public function execute()
    {
        if (!file_exists(realpath(dirname(__FILE__) . '/../maintenance/') . DIRECTORY_SEPARATOR . 'maintenance.php')) {
            return;
        }
        
        // メンテナンス除外処理などを書く
        
        // メンテナンスページを表示orリダイレクトし、終了
        exit();
    }
}

Optimacms.config do |c|
  c.main_namespace = ''
  c.admin_namespace = 'admin'
  c.files_dir_path = 'img'

end



# OLD. for version < 0.3.30
=begin
Optimacms.main_namespace = '' # blank or any like 'cms'
Optimacms.admin_namespace = 'admin'
Optimacms.files_dir_path = 'img'

Optimacms.backup_metadata = {
    dir_base: "/data/backups/cms/metadata"
}
=end
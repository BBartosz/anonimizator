require './anonimizator'
require './backup'

def start(yaml_path, original_db_backup_name, anonimized_db_backup_name, tables_columns)
  backup = Backup.new(yaml_path)
  original_db = backup.create_backup(original_db_backup_name)

  if original_db
    anonim = Anonimizator.new(yaml_path, tables_columns) 
    backup.create_backup(anonimized_db_backup_name) if anonim.can_connect?
    backup.restore_backup(original_db_backup_name)
  else
    puts "Cannot anonimize, cannot make backup of original db"
    return 
  end
end

tables_columns = {:offer => ["city", "property_form"], :user => ['email']}
start('database.yml', 'original', 'anonimized', tables_columns)

require './anonimizator'
require './backup'
require 'rspec'

def start(yaml_path, original_backup_name, anonimized_backup_name, tables_columns)
  backup = Backup.new(yaml_path)
  original_db = backup.create_backup(original_backup_name)
  if original_db
    anonim = Anonimizator.new(yaml_path, tables_columns)
    puts "Zanonimizowano bazę"
    backup.create_backup(anonimized_backup_name) if anonim.can_connect?
    backup.restore_backup(original_backup_name)
    puts "Przywrócono backup oryginalnej bazy"
  else
    puts "Cannot anonimize, cannot make backup of original db"
    return 
  end
end

tables_columns = {:offer => ["city", "property_form"], :user => ['email']}
start('database.yml', 'original', 'anonimized', tables_columns)


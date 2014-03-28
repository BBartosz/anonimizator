require './anonimizator'
require './backup'
require 'rspec'

# class ScriptError < StandardError
#   def initialize(msg = "ScriptError occured.")
#     super(msg)
#   end
# end

def start(yaml_path, tables_columns, db_environment)
  backup = Backup.new(yaml_path, db_environment)
  original_db = backup.create_backup('original')
  if original_db
    anonim = Anonimizator.new(yaml_path, tables_columns, db_environment)
    puts "Zanonimizowano bazę"
    backup.create_backup('anonimized')
    backup.restore_backup('original')
    puts "Przywrócono backup oryginalnej bazy"
  else
    puts "Cannot anonimize, cannot make backup of original db"
    return 
  end
end

tables_columns = {'offer' => ["city", "property_form"], 'user' => ['email']}
start('database.yml', tables_columns, 'development')


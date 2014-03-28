require './anonimizator'
require './backup'
require 'rspec'



def start(yaml_path, tables_columns, db_environment)
  begin
    backup = Backup.new(yaml_path, db_environment)
    backup.create_backup('original')
    anonim = Anonimizator.new(yaml_path, tables_columns, db_environment)
    puts "Zanonimizowano bazę"
    backup.create_backup('anonimized')
    backup.restore_backup('original')
    puts "Przywrócono backup oryginalnej bazy"
  rescue Exception => e  
    puts e
  end
end

# tables_columns = {'offer' => ["city", "property_form"], 'user' => ['email']}
# class Record < ActiveRecord::Base
# end

# connection = ActiveRecord::Base.establish_connection(YAML.load_file('database.yml')['development'])

# tables_columns.each do |table, column|
#   Record.table_name = table
#   puts Record.all
# end

tables_columns = {'offer' => ["city", "property_form"], 'user' => ['email']}
start('database.yml', tables_columns, 'development')


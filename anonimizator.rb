require 'rubygems'
require 'active_record'
require 'mysql2'
require 'fileutils'
require './backup'

class Anonimizator

  def connect_to_db(yaml_path)
    yaml_file        = YAML.load_file(yaml_path)
    connection_to_db = ActiveRecord::Base.establish_connection(yaml_file['development'])
  end

  def select_tables(hash_names_columns)
    hash_names_columns.each do |table_name, columns_array|
      class_name    = table_name.capitalize
      table_object  = Object.const_set(class_name, Class.new(ActiveRecord::Base))
      anonimize_records(table_object, columns_array)
    end  
  end
  
  def anonimize_records(table, columns_array)
    table.all.each do |record|
      columns_array.each do |column|
        if column == 'email'
          at_sign_index = record[column].index('@')
          record_to_replace = record[column][0] + '-' * (record[column][0..at_sign_index-1].length - 2) + record[column][at_sign_index-1] + record[column][at_sign_index..-1] if record[column][0..at_sign_index-1].length >= 2
          puts record_to_replace
        else
          record_to_replace = record[column][0] + '-' * (record[column].length - 2) + record[column][-1]
          record.update_attribute(column, record_to_replace ) 
        end
      end
    end
  end

end



anonim = Anonimizator.new
anonim.connect_to_db('database.yml')

anonim.select_tables({:user => ['email']})
backup = Backup.new('database.yml')
backup.create_backup
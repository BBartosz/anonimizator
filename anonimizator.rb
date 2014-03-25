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
        anonimize_column(record, column)
      end
    end
  end

  def anonimize_column (record, column)
    if column.include? ('@')
      record_to_replace = anonimize_email(record[column])
      record.update_attribute(column, record_to_replace)
    else
      record_to_replace = record[column] 
      record_to_replace[1..-2] = anonimize_string(record[column])
      record.update_attribute(column, record_to_replace) 
    end
  end

  def anonimize_email(email)
    parts    = email.split('@')
    parts[0][1..-2] = anonimize_string(parts[0])
    parts.join('@')
  end

  def anonimize_string(string)
    return string if string.length < 3
    string[1..-2] = '-' * (string.length - 2)
  end
end



anonim = Anonimizator.new
anonim.connect_to_db('database.yml')

anonim.select_tables({:offer => ["city", "property_form"], :user => ['email']})
# backup = Backup.new('database.yml')
# backup.create_backup
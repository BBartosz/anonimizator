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

  def select_tables(table_columns)
    table_columns.each do |table_name, columns_array|
      table_object  = Object.const_set(table_name.capitalize, Class.new(ActiveRecord::Base))
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
    if record[column].include? ('@')
      replace_str = anonimize_email(record[column])
      record.update_attribute(column, replace_str)
    else
      replace_str        = record[column] 
      replace_str[1..-2] = anonimize_string(record[column])
      record.reload.update_attribute(column, replace_str)
    end
  end

  def anonimize_email(email)
    parts           = email.split('@')
    parts[0][1..-2] = anonimize_string(parts[0])
    parts.join('@')
  end

  def anonimize_string(string)
    return string if string.length < 3
    string[1..-2] = '-' * (string.length - 2)
  end
end




backup = Backup.new('database.yml', 'original')
backup.create_backup
anonim = Anonimizator.new
anonim.connect_to_db('database.yml')

anonim.select_tables({:offer => ["city", "property_form"], :user => ['email']})
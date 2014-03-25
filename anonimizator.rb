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
          record_to_replace = anonimize_email(record[column])
          ecord.update_attribute(column, record_to_replace)
        else
          record_to_replace = anonimize_string(record[column])
          record.update_attribute(column, record_to_replace) 
        end
      end
    end
  end

  def anonimize_email(emailstring)
    splitted_email_array = emailstring.split('@')
    first_part_of_email  = splitted_email_array[0]
    splitted_email_array[0]  = first_part_of_email[0] + '-' * (first_part_of_email.length - 2) + first_part_of_email[-1]
    splitted_email_array.join('@')
  end

  def anonimize_string(string)
    string[0] + '-' * (string.length - 2) + string[-1]
  end
end



anonim = Anonimizator.new
anonim.connect_to_db('database.yml')

anonim.select_tables({:offer => ['city'], :user => ['email']})
backup = Backup.new('database.yml')
backup.create_backup
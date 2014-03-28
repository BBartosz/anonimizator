require 'rubygems'
require 'active_record'
require 'mysql2'
require 'fileutils'

class Anonimizator

  def initialize(yaml_path, tables_columns, db_environment)
    @yaml_file = YAML.load_file(yaml_path)[db_environment]
    @yaml_file['password'] = '' if @yaml_file['password'] == nil

    if ActiveRecord::Base.establish_connection(@yaml_file)
      anonimize_tables(tables_columns) 
    else
      puts "Specify password in your yaml file, cannot anonimize."
    end
  end

  def anonimize_tables(table_columns)
    table_columns.each do |table_name, columns_array|
      table_object  = Object.const_set(table_name.capitalize, Class.new(ActiveRecord::Base))
      anonimize_records(table_object, columns_array)
    end  
  end
  
  def anonimize_records(table, columns_array)
    table.all.each do |record|
      columns_array.each do |column|
        anonimize_field(record, column) if record[column].class == String && record[column].length > 2
      end
    end
  end

  def anonimize_field(record, column)
    anonimized_field = anonimize(record, column)
    record.update_attribute(column, anonimized_field)
  end

  def anonimize(record, column)
    if record[column].include? ('@')
      anonimize_email(record[column])
    else
      anonimize_string(record[column])
    end
  end

  def anonimize_email(email)
    email                 = email.split('@')
    anonimized_email_name = anonimize_string(email[0])
    "#{anonimized_email_name}@#{email[1]}"
  end

  def anonimize_string(string)
    return string if string.length < 3

    anonimized = '-' * (string.length - 2)
    string[0] + anonimized + string[-1]
  end
end


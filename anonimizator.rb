require 'rubygems'
require 'active_record'
require 'mysql2'
require 'table_print'
class Anonimizator
  def connect_to_db(yaml_path)
    yaml_file = YAML.load_file(yaml_path)
    connection_to_db = ActiveRecord::Base.establish_connection(yaml_file['development'])
  end

  def select_tables(*tables)
    tables.each do |table|
      class_name = table.capitalize
      class_def = Object.const_set(class_name, Class.new(ActiveRecord::Base))
      tp class_def.all
    end
  end
end

anonim = Anonimizator.new
anonim.connect_to_db('database.yml')
anonim.select_tables('offer', 'user')
# class Offer < ActiveRecord::Base
# end

# Offer.all.each do |o|
#   puts "o: #{o.inspect}"
# end

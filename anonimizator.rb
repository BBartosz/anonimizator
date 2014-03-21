require 'rubygems'
require 'active_record'
require 'mysql2'

class Anonimizator
  def connect_to_db(yaml_path)
    yaml_file = YAML.load_file(yaml_path)
    connection_to_db = ActiveRecord::Base.establish_connection(yaml_file['development'])
  end
end

anonim = Anonimizator.new
anonim.connect_to_db('database.yml')

class Offer < ActiveRecord::Base
end

Offer.all.each do |o|
  puts "o: #{o.inspect}"
end

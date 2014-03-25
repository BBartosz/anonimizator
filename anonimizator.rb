require 'rubygems'
require 'active_record'
require 'mysql2'
require 'fileutils'

class Anonimizator
  def connect_to_db(yaml_path)
    yaml_file        = YAML.load_file(yaml_path)
    puts yaml_file
    connection_to_db = ActiveRecord::Base.establish_connection(yaml_file['development'])
  end

  def select_tables(*tables)
    tables.each do |table|
      class_name = table.capitalize
      class_def  = Object.const_set(class_name, Class.new(ActiveRecord::Base))

      class_def.all.each do |oferta|
        oferta.update_attribute(:city, '-' * oferta.city.length) 
      end
    end
  end

end

class Backup
  DB_NAME_PREFIX = 'db_'

  def initialize(yaml_path)
    @yaml_file = YAML.load_file(yaml_path)
  end
  
  def check_path(time)
    full_backup_path = "#{Dir.pwd}/backup/#{time}/"
    check_path       = ''

    full_backup_path.split('/').each { |el|
      check_path += "#{el}/"
      Dir.mkdir(check_path) unless File.directory?(check_path)
    }
  end

  def db_info
    @yaml_file['development']
  end

  def create_backup
    time = Time.now
    created_at = time
    file_time  = time.strftime("%Y\-%m\-%d_%H\-%M\-%S")
    check_path file_time
    backup_db_dir = "#{Dir.pwd}/backup/#{file_time}/#{DB_NAME_PREFIX}#{file_time}.sql"
    
    db_user = db_info['username']
    db_pass = db_info['password']
    db_host = db_info['host']
    db      = db_info['database']

    exec "mysqldump --add-drop-table -u #{db_user} -p#{db_pass} -h #{db_host} #{db}  > #{backup_db_dir}" if fork.nil?

  end
end

anonim = Anonimizator.new
anonim.connect_to_db('database.yml')
anonim.select_tables('offer')

# backup = Backup.new('database.yml')
# backup.create_backup
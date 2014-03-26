class Backup

  def initialize(yaml_path, db_name)
    @yaml_file = YAML.load_file(yaml_path)
    @db_name   = db_name
  end

  def db_info
    @yaml_file['development']
  end

  def create_backup    
    db_user = db_info['username']
    db_pass = db_info['password']
    db_host = db_info['host']
    db      = db_info['database']

    exec "mysqldump --add-drop-table -u #{db_user} -p#{db_pass} -h #{db_host} #{db}  > #{@db_name}"

  end
end
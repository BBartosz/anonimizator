class Backup

  def initialize(yaml_path)
    @yaml_file  = YAML.load_file(yaml_path)

    dev_db_info = @yaml_file['development']

    @db_user    = dev_db_info['username']
    @db_pass    = dev_db_info['password']
    @db_host    = dev_db_info['host']
    @db         = dev_db_info['database']
  end

  def create_backup(name)
    system("mysqldump --add-drop-table -u#{@db_user} -p#{@db_pass}  #{@db} > #{name}.sql") 
  end

  def restore_backup(name)
    system("mysql -u#{@db_user} -p#{@db_pass} #{@db} < #{name}.sql")
  end

end

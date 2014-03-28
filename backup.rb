require './error'

class Backup

  def initialize(yaml_path, db_environment)
    @yaml_file  = YAML.load_file(yaml_path)[db_environment]

    @db_user    = @yaml_file['username']
    @db_pass    = @yaml_file['password']
    @db_host    = @yaml_file['host']
    @db         = @yaml_file['database']
  end

  def create_backup(name)
    if @db_pass.nil? || @db_pass == ''
      raise Error.new("Cannot create backup") if !system("mysql -u#{@db_user} #{@db} < #{name}.sql")
    else
      raise Error.new("Cannot create backup") if !system("mysql -u#{@db_user} -p#{@db_pass} #{@db} < #{name}.sql")
    end      
  end

  def restore_backup(name)
    if @db_pass.nil? || @db_pass == ''
      raise Error.new("Cannot restore backup") if !system("mysql -u#{@db_user} #{@db} < #{name}.sql")
    else
      raise Error.new("Cannot restore backup") if !system("mysql -u#{@db_user} -p#{@db_pass} #{@db} < #{name}.sql")
    end
  end

end

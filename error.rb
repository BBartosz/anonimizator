class Error < StandardError
  def initialize(msg = "Error occured.")
    super(msg)
  end
end
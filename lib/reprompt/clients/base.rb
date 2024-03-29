class Base
  attr_accessor :uri
  
  def initialize
  end

  def prompt(question)
    raise NotImplementedError
  end
end
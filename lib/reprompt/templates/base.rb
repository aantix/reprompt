require_relative '../clients/ollama'

class Base
  attr_accessor :client, :conversation, :max_responses

  def initialize(max_responses = 5)
    @client = Ollama.new
    @max_responses = max_responses
  end

  def prompt(question)
    raise NotImplementedError, "Each template should implement it's own conversation."
  end
end
require 'net/http'
require 'uri'
require 'json'
require_relative 'base'

class Ollama < Base
  def initialize
    @uri = URI('http://localhost:11434/api/chat')
  end

  def prompt(question)
    response = Net::HTTP.start(@uri.hostname, @uri.port, use_ssl: @uri.scheme == 'https') do |http|
      http.post(@uri, JSON.dump({
                                  messages: [{ role: 'user', content: question }],
                                  model: 'mistral',
                                  stream: false
                                }), 'Content-Type' => 'application/json')
    end

    (JSON.parse(response.body) || {}).dig('message', 'content')
  end
end

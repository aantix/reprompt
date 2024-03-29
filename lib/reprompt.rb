# frozen_string_literal: true

require_relative "reprompt/version"
require_relative 'reprompt/conversation'

require_relative 'reprompt/clients/base'
require_relative 'reprompt/clients/ollama'

require_relative 'reprompt/templates/base'
require_relative 'reprompt/templates/five_whys'
require_relative 'reprompt/templates/technical_outline'

module Reprompt
  class Error < StandardError; end
  # Your code goes here...
end

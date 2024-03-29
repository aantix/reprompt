require_relative 'base'

class TechnicalOutline < Base
  def prompt(question)
    @conversation = Conversation.new(client, max_responses) do
      stop_condition do |depth, response|
        response.include?("we are done") || depth >= max_responses
      end

      follow_up_on do |response|
        prompt "What is a good follow up question for #{response}? No compliments, no commentary, just a short follow up question. Or are we done?"
      end
    end

    conversation.start(question)
  end
end
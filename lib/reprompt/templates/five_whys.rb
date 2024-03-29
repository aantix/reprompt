require_relative 'base'

class FiveWhys < Base
  def prompt(question)
    @conversation = Conversation.new(client, max_responses) do
      stop_condition do |depth, response|
        response.include?("i do not know") || depth >= @max_responses
      end

      follow_up_on do |_response|
        ['Why is that?',
         'What do you mean by that?',
         'Are there other approaches?',
         'Can you clarify?'].shuffle.first
      end
    end

    conversation.start(question)
  end
end
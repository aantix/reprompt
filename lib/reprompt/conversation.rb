class Conversation
  attr_accessor :max_responses, :conversation_context, :client

  def initialize(client, max_responses = 5, &configuration)
    @client = client
    @max_responses = max_responses
    @stop_condition_block = nil
    @follow_up_block = nil
    @conversation_context = []
    instance_eval(&configuration) if block_given?
  end

  def stop_condition(&block)
    @stop_condition_block = block
  end

  def follow_up_on(&block)
    @follow_up_block = block
  end

  def start(initial_question)
    depth = 0
    conversation_context.clear
    current_question = initial_question
    previous_response = ""

    while continue_conversation?(depth, previous_response)
      response = @client.prompt(current_question_with_previous_context(current_question, conversation_context))
      puts "###Q: #{current_question}"
      puts "####A: #{response}"
      conversation_context << { role: 'system', content: response }

      previous_response = response
      depth += 1

      break unless @follow_up_block

      current_question = instance_exec(response, &@follow_up_block)
    end

    current_conversation
  end

  private

  def current_question_with_previous_context(current_question, conversation_context)
    "#{current_conversation}#{current_question}"
  end

  def current_conversation
    conversation_context.join("\n")
  end

  def previous_context
    conversation_context.join("\n")
  end

  def continue_conversation?(depth, previous_response)
    return !@stop_condition_block.call(depth, previous_response) if @stop_condition_block

    depth < @max_responses
  end

  def prompt(question)
    client.prompt(question)
  end
end

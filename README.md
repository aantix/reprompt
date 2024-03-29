# Reprompt

Provides a pattern for iteratively prompting an LLM and asking follow up questions based on the response.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add reprompt

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install reprompt
                          
The only client adapter at the current moment is for Ollama.  So you'll have to run a model locally.

Mistral is really good.

```
brew install ollama
brew services start ollama
ollama pull mistral
```

## Pattern

Take a look in `reprompt/templates`.  Return a `true/false` for the `stop_condition` callback.
Return a string (question, response, etc) for the `follow_up_on` callback.

Here's the basic pattern.

```ruby
require_relative 'base'

class TechnicalOutline < Base
  def prompt(question)
    @conversation = Conversation.new(client, max_responses) do
      stop_condition do |depth, response|
        response.include?("we are done") || depth >= max_responses
      end

      follow_up_on do |response|
        # We'll have the Mistral LLM create our next follow up question
        prompt "What is a good follow up question for #{response}?  Or are we done?"
      end
    end

    conversation.start(question)
  end
end
```
       
## Usage

```ruby
template = TechnicalOutline.new
template.prompt("Outline the difference between a Ruby include vs prepend")
```

### The Resulting Article

### Q: Outline the difference between a Ruby include vs prepend
#### A:  In Ruby, `include` and `prepend` are two methods used to add functionality to a class or module. However, they serve different purposes:

1. **Include:** The `include` method adds the methods (and constants, if any) of one module into another module or class. When you include a module into a class, all the methods defined in that module become available in the class. The instance methods are mixed-in and will be accessible on instances of the class. The class itself does not inherit from the included module.

2. **Prepend:** The `prepend` method also adds the functionality of one module into another module or class, but it does so in a different way. When you prepend a module to a class, the methods defined in that module are added at the beginning (before all other instances and class methods) of the class's method chain. This can be useful when you want to modify or extend existing methods without overriding them completely.

Here is an example to illustrate the difference between `include` and `prepend`. Let's assume we have two modules: `MyModule1` and `MyModule2`. Both modules define a method called `my_method`.

```ruby
module MyModule1
  def my_method
    puts "MyModule1: my_method"
  end
end

module MyModule2
  def my_method
    puts "MyModule2: my_method"
  end
end
```

Now, let's see how we can use these modules with the `include` and `prepend` methods:

**Using include:**

```ruby
class MyClass
  include MyModule1
  include MyModule2
end

MyClass.new.my_method # Output: "MyModule1: my_method" (because MyModule1 is included last)
```

In this example, `MyModule1` and `MyModule2` are included in the order they appear, so when you call `my_method` on an instance of `MyClass`, it will output "MyModule1: my_method". If we want to change the order, we would have to change the order in which the modules are included.

**Using prepend:**

```ruby
class MyClass
  prepend MyModule2
  include MyModule1
end

MyClass.new.my_method # Output: "MyModule2: my_method" (because MyModule2 is prepended)
```

In this example, `MyModule2` is prepended to the class before including `MyModule1`. When you call `my_method` on an instance of `MyClass`, it will output "MyModule2: my_method" because `MyModule2` is added at the beginning of the method chain.
### Q:  A possible follow-up question could be:

Can you explain some use cases where it would be more appropriate to use `include` instead of `prepend`, and vice versa, when extending or modifying the functionality of a class or module in Ruby? Also, are there any limitations or drawbacks to using one method over the other, depending on the specific scenario?
#### A:  Sure! The choice between `include` and `prepend` depends on your specific use case and the desired outcome. Here are some common scenarios where each method might be more appropriate:

**Use Cases for Include:**

1. When you want to add new methods or functionalities to an existing class or module, without modifying any of the existing methods. This is because `include` adds the methods at the end of the class's method chain.
2. When you have multiple modules that define similar but not identical functionality and you want to mix them into a single class or module. The order in which you include these modules may impact the behavior of your class/module, so consider the dependencies carefully.
3. When the added methods are optional or can be easily overridden by other methods in the class/module.
4. When working with mixins or libraries that provide additional functionality to your classes or modules.

**Use Cases for Prepend:**

1. When you want to modify existing methods without overriding them completely. By prepending a module, you can add new behavior at the beginning of the method chain, which will be executed before the original implementation of the method. This is useful when you need to perform some additional setup or validation for a method.
2. When dealing with third-party libraries that provide methods or functionalities that you want to modify or extend without modifying the library's source code directly. Prepending your custom module allows you to hook into existing methods and add new functionality while keeping the original behavior intact.
3. When working on deeply nested inheritance hierarchies, where you need to modify the behavior of a method at a specific level in the hierarchy. By prepending the modifying module at that level, you can modify the behavior without affecting other levels in the hierarchy.

Limitations and Drawbacks:

1. **Naming Conflicts:** If two included modules or prepended modules define methods with the same name, there will be a naming conflict. In this case, you need to provide an alias or rename one of the conflicting methods.
2. **Complexity:** Using both `include` and `prepend` in the same class/module can make the codebase more complex and harder to understand for other developers. Try to keep your use of these methods clear and concise.
3. **Ordering Dependencies:** The order in which you include or prepend modules matters, as it impacts the method chain. Make sure to consider the dependencies carefully and provide a clear ordering if necessary.
   ### Q:  What are some best practices for managing the order of dependencies when using `include` and `prepend` in Ruby?
   #### A:  When managing dependencies in Ruby with `include` and `prepend`, here are some best practices to ensure clear and consistent code:

1. **Declare dependencies explicitly:** Make sure to declare all dependencies (included modules or prepended modules) at the beginning of your class definition, preferably in the order they should be processed. This makes it easier for other developers to understand the flow of your code.

2. **Use descriptive names:** Give meaningful and descriptive names to your modules to make it clear what functionality they provide. This helps when determining the correct order of dependencies.

3. **Minimize the number of dependencies:** Try to keep the number of dependencies to a minimum, as more dependencies lead to increased complexity and potential for conflicts. If possible, refactor your code to reduce the number of dependencies.

4. **Consider encapsulation:** Encapsulate related functionality within the same module or library to minimize dependency conflicts and simplify the ordering process.

5. **Maintain a clear documentation:** Clearly document each module's purpose and intended use, along with any specific requirements or dependencies. This will help other developers understand the context of your code.

6. **Test thoroughly:** Thoroughly test your code to ensure that the order of dependencies does not impact the functionality or behavior of your classes or modules. This can help you identify and resolve potential conflicts early in the development process.
   ### Q:  A possible follow-up question could be: "What are some common pitfalls to avoid when managing dependencies with `include` and `prepend` in Ruby?" or "Can you provide examples of how these best practices for managing dependencies with `include` and `prepend` in Ruby can be implemented in practice?"
   #### A:  When managing dependencies with `include` and `prepend` in Ruby, there are some common pitfalls to avoid:

1. **Naming conflicts:** As mentioned earlier, if two included modules or prepended modules define methods with the same name, there will be a naming conflict. To avoid this, you can provide an alias or rename one of the conflicting methods. Make sure to check for potential naming conflicts before incorporating new dependencies into your codebase.
2. **Complexity:** Using both `include` and `prepend` in the same class/module can make the codebase more complex and harder to understand for other developers. Try to keep your use of these methods clear and concise, and avoid adding unnecessary dependencies.
3. **Inconsistent ordering:** The order in which you include or prepend modules matters. If dependencies are not declared consistently across your codebase, it can lead to unexpected behavior or bugs. Be sure to declare all dependencies at the beginning of your class definition, preferably in the correct order.
4. **Circular dependencies:** Circular dependencies occur when modules A and B each depend on the other. This can create a deadlock situation where neither module can be loaded properly. Avoid circular dependencies by ensuring that each module depends only on its direct dependencies and not on indirect dependencies.
5. **Lack of documentation:** Failing to document your dependencies clearly can lead to confusion and misinterpretation of your code. Be sure to provide clear and concise documentation for each module, including its purpose, intended use, and any specific requirements or dependencies.

Here's an example of how you might implement some of these best practices in practice:

```ruby
# Define a simple logging module with two methods: info and error
module Logging
  def log_info(message)
    puts "[INFO] #{message}"
  end

  def log_error(message)
    puts "[ERROR] #{message}"
  end
end

# Define a validation module with two methods: validate_presence and validate_format
module Validation
  def validate_presence(attribute, value)
    raise "Attribute '#{attribute}' is missing" if value.nil?
  end

  def validate_format(attribute, format)
    raise "Invalid format for attribute '#{attribute}' (expected: #{format})" unless value =~ /#{format}/
  end
end

# Define a User class that includes Logging and Validation modules
class User
  include Logging
  include Validation

  attr_accessor :name, :email

  def initialize(name, email)
    @name = name
    @email = email
  end

  # Method to create a new user with validation and logging
  def create
    validate_presence(:name, @name)
    validate_format(:email, /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.([a-z\d]([a-z\d\-.]*){2,})\z/)

    log_info("Created new user: #{@name}")
  end
end
```

In this example, we define two simple modules (Logging and Validation) with their respective methods. We then include these modules in a User class, which includes both logging and validation functionality. By documenting each module clearly and encapsulating related functionality within the same module, we can minimize complexity and potential for conflicts. Additionally, by declaring dependencies explicitly at the beginning of our class definition, we make it easier for other developers to understand the flow of our code.
### Q: A possible follow-up question could be: "Can you explain how the order of inclusion matters when dealing with dependencies in Ruby using `include` and `prepend`, and provide an example of unexpected behavior that might occur due to inconsistent ordering?"
#### A: Absolutely! When managing dependencies in Ruby with `include` and `prepend`, the order in which you include or prepend modules is crucial. This is because the order determines the method chain for each class or module, and can impact the behavior of your code.\
\
Let's consider an example where we have two modules, `ModuleA` and `ModuleB`, with each defining a method named `method_x`. If we include or prepend these modules in different orders, it can lead to unexpected behavior:\
```ruby\n\n# Define ModuleA with method x\nmodule ModuleA\n  def method_x\n    puts "Method X from Module A"\n  end\nend\n\n# Define ModuleB with method x\nmodule ModuleB\n  def method_x\n    puts "Method X from Module B"\n  end\nend\n\nclass MyClass\n  # Inconsistent ordering: include ModuleA, then include ModuleB\n  include ModuleA\n  include ModuleB\n\n  # Expected output: "Method X from Module A" when calling method_x\nend\n\n# Output: "Method X from Module B" instead of "Method X from Module A", due to inconsistent ordering\nMyClass.new.method_x\n```
In the example above, we define two modules, `ModuleA` and `ModuleB`, each with a method named `method_x`. We then create a class called `MyClass`, which includes both `ModuleA` and `ModuleB` in an inconsistent order. This results in the `method_x` from `ModuleB` being called instead of `ModuleA` when we call `my_class.new.method_x`.
\
The inconsistent ordering can cause unexpected behavior because each module extends the previous one, creating a chain of inheritance that determines which method is actually called when you invoke a method with that name. In our example, because we included `ModuleB` after `ModuleA`, Ruby uses the definition of `method_x` from `ModuleB` instead of `ModuleA`.
\
To avoid unexpected behavior due to inconsistent ordering, make sure to declare all dependencies at the beginning of your class definition, preferably in the correct order. In our example above, we should have included `ModuleA` before `ModuleB`:
```ruby\nclass MyClass\n  include ModuleA\n  include ModuleB\n  # Expected output: "Method X from Module A" when calling method_x\nend\n```
This way, we ensure that the definition of `method_x` from `ModuleA` is used instead of `ModuleB`, as intended.
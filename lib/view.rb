# frozen_string_literal: true

# This class is responsible for input and output
class View
  def display_message(output)
    puts output
  end

  def display_error(output)
    puts "Error! #{output}"
  end

  def ask_for_input
    gets.chomp
  end

  def welcome
    display_output "Welcome to Clockwork! run 'clockwork.rb -h' for help."
  end

  def too_many_options
    display_output "Too many options! run 'clockwork.rb -h' for help."
  end
end

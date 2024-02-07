# frozen_string_literal: true

require 'cli/ui'
CLI::UI::StdoutRouter.enable

# This class is responsible for input and output
class View
  def display_message(output)
    frame { puts output }
  end

  def display_success(output)
    success_frame { puts output }
  end

  def display_error(output)
    error_frame { puts output }
  end

  def ask_for_input(question)
    frame do
      CLI::UI::Prompt.ask(question)
    end
  end

  def ask_for_option(question, options)
    frame do
      CLI::UI::Prompt.ask(question) do |handler|
        options.each { |option| handler.option(option) { |selection| selection } }
      end
    end
  end

  def welcome
    display_message "Welcome to Clockwork! run 'clockwork.rb -h' for help."
  end

  def too_many_options
    display_message "Too many options! run 'clockwork.rb -h' for help."
  end

  def no_projects
    display_error('No projects yet. Please create a project first. Run clockwork.rb -h for help')
  end

  def display_projects(projects)
    frame do
      puts 'Your projects:'
      projects.each do |project|
        puts "#{project.name}#{project.status} | Total time: #{project.total_time_in_hours_minutes}"
      end
    end
  end

  def total_time(project)
    frame do
      puts "Total time for project #{project.name}: #{project.total_time_in_hours_minutes}"
      puts "That's #{project.total_time_working_days(8)} working days (8h/day)"
    end
  end

  private

  def frame(&block)
    CLI::UI::Frame.open('Clock Work', &block)
  end

  def success_frame(&block)
    CLI::UI::Frame.open('Clock Work', color: :green, &block)
  end

  def error_frame(&block)
    CLI::UI::Frame.open('Clock Work | Error', color: :red, &block)
  end
end

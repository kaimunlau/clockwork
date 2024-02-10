# frozen_string_literal: true

require 'cli/ui'
CLI::UI::StdoutRouter.enable

# This class is responsible for input and output
class View
  def display_message(output)
    frame { puts output }
  end

  def display_success(output)
    success_frame { puts CLI::UI.fmt "{{green:#{output}}}" }
  end

  def display_error(output)
    error_frame { puts CLI::UI.fmt "{{red:#{output}}}" }
  end

  def ask_for_input(question)
    frame('{{?}}') do
      CLI::UI::Prompt.ask(question)
    end
  end

  def ask_for_option(question, options)
    frame('{{?}}') do
      CLI::UI::Prompt.ask(question) do |handler|
        options.each { |option| handler.option(option) { |selection| selection } }
      end
    end
  end

  def welcome
    display_message "Welcome to Clockwork! run 'clockwork.rb -h' for help."
  end

  def too_many_options
    display_error "Too many options! run 'clockwork.rb -h' for help."
  end

  def no_projects
    display_error('No projects yet. Please create a project first. Run clockwork.rb -h for help')
    exit
  end

  def display_projects(projects)
    frame('All projects') do
      projects.each_with_index do |project, index|
        puts CLI::UI.fmt "{{bold:Project:}} #{project.name}"
        puts CLI::UI.fmt "{{bold:Status:}} #{project.session_running? ? 'Running' : 'Paused'}"
        puts CLI::UI.fmt "{{bold:Total time:}} #{project.total_time_in_hours_minutes}"
        CLI::UI::Frame.divider('') unless index == projects.length - 1
      end
    end
  end

  def total_time(project)
    frame(CLI::UI.fmt("{{bold:Project:}} #{project.name}")) do
      puts CLI::UI.fmt "{{bold:Total time:}} #{project.total_time_in_hours_minutes}"
      puts CLI::UI.fmt "{{bold:Sessions:}} #{project.sessions.count}"
      CLI::UI::Frame.divider('{{i}}')
      puts "That's #{project.total_time_working_days(8)} working days (8h/day)"
    end
  end

  def frame(title = '{{*}}', style = :bracket, color = :cyan, &block)
    CLI::UI.frame_style = style
    CLI::UI::Frame.open(title, color: color, &block)
  end

  private

  def success_frame(&block)
    CLI::UI.frame_style = :bracket
    CLI::UI::Frame.open('{{v}}', color: :green, &block)
  end

  def error_frame(&block)
    CLI::UI.frame_style = :bracket
    CLI::UI::Frame.open('{{x}}', color: :red, &block)
  end
end

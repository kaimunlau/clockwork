# frozen_string_literal: true

# This class is responsible for executing the logic based on the options provided by the user.
class Controller
  def initialize(options, view)
    @options = options
    @view = view
  end

  def execute
    return @view.welcome if @options.empty?

    return @view.too_many_options if @options.length > 1

    # TODO: Implement the logic to execute various actions based on the options
    new_project if @options[:new]
    start_session(@options[:start]) if @options[:start]
  end

  private

  def new_project
    project_name = @view.ask_for_input('What is the name of your project?')
    project = Project.new(name: project_name)
    save_project(project)
  end

  def save_project(project)
    if project.valid?
      project.save
      @view.display_success("Project '#{project.name}' created successfully")
    else
      @view.display_error("Could not create project '#{project.name}': #{project.errors.full_messages.join(', ')}")
    end
  end

  def start_session(project_name)
    @view.display_message('Enter the name of the project:') if project_name.empty?

    puts "Starting timer for project '#{project_name}'..."
  end
end

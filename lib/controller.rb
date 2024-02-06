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
  end

  private

  def new_project
    @view.display_message('Enter the name of the project:')
    project_name = @view.ask_for_input
    project = Project.new(name: project_name)
    if project.valid?
      project.save
      @view.display_message("Project '#{project_name}' created successfully")
    else
      @view.display_error("Could not create project '#{project_name}': #{project.errors.full_messages.join(', ')}")
    end
  end
end

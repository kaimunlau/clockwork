# frozen_string_literal: true

# This class is responsible for executing the logic based on the options provided by the user.
class Router
  def initialize(options, view, projects_controller, sessions_controller)
    @options = options
    @view = view
    @projects_controller = projects_controller
    @sessions_controller = sessions_controller
  end

  def execute
    return @view.welcome if @options.empty?

    return @view.too_many_options if @options.length > 1

    pick_action
  end

  private

  def pick_action
    case @options.keys.first
    when :new then new_project
    when :start then start_session(@options[:start])
    when :pause then end_session
    when :list then list_projects
    when :total then total_time(@options[:total])
    when :delete then delete_project
    end
  end

  def new_project
    project_name = @view.ask_for_input('What is the name of your project?')
    @projects_controller.create(project_name)

    return unless @view.ask_for_option('Do you want to start a session for this project?', %w[Yes No]) == 'Yes'

    start_session(project_name)
  end

  def start_session(project_name)
    return @view.no_projects if Project.all.empty?

    if Session.where(end_time: nil).first
      return @view.display_error('There is already a running session! Please end it before starting a new one.')
    end

    project_name = project_name_from_list if project_name.empty?
    project = Project.first(name: project_name)

    # check if a session is already running for this project
    # if it is, display a message
    return @view.display_message("A session is already running for project #{project.name}") if project.session_running?

    # else, start a new session
    @sessions_controller.create(project)
  end

  def project_name_from_list
    @view.ask_for_option('Enter the name of the project:', Project.all.map(&:name))
  end

  def save_session(session, verb)
    if session.valid?
      session.save
      @view.display_success("Session #{verb}ed for project '#{session.project.name}'")
    else
      @view.display_error("Could not #{verb} session for project '#{session.project.name}': #{session.errors.full_messages.join(', ')}")
    end
  end

  def end_session
    session = Session.where(end_time: nil).first
    return @view.display_error('No session is running') if session.nil?

    session.end_time = Time.now
    save_session(session, 'end')
  end

  def list_projects
    @projects_controller.index
  end

  def total_time(project_name)
    project_name = project_name_from_list if project_name.empty?
    project = Project.first(name: project_name)
    return @view.display_error("Project '#{project_name}' not found") if project.nil?

    @view.total_time(project)
  end

  def delete_project
    project_name = project_name_from_list
    @projects_controller.delete(project_name)
  end
end

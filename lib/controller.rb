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
    end_session if @options[:pause]
    list_projects if @options[:list]
  end

  private

  def new_project
    project_name = @view.ask_for_input('What is the name of your project?')
    project = Project.new(name: project_name)
    save_project(project)

    return unless @view.ask_for_option('Do you want to start a session for this project?', %w[Yes No]) == 'Yes'

    start_session(project_name)
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
    return @view.no_projects if Project.all.empty?

    project_name = project_name_from_list if project_name.empty?
    project = Project.first(name: project_name)

    # check if a session is already running for this project
    # if it is, display a message
    return @view.display_message("A session is already running for project #{project.name}") if project.session_running?

    # else, start a new session
    session = Session.new(project_id: project.id, start_time: Time.now)
    save_session(session, 'start')
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
    projects = Project.all
    return @view.no_projects if projects.empty?

    @view.display_projects(projects)
  end
end

# frozen_string_literal: true

# This class is responsible for managing the logic of projects
class ProjectsController
  def initialize(view)
    @view = view
  end

  def index
    projects = Project.all
    return @view.no_projects if projects.empty?

    @view.display_projects(projects)
  end

  def create(project_name)
    project = Project.new(name: project_name)
    save_project(project)
  end

  def delete(project_name)
    project = Project.first(name: project_name)

    return if @view.ask_for_option("Are you sure you want to delete project '#{project_name}'?", %w[No Yes]) == 'No'

    project.sessions.each(&:destroy)
    project.destroy
    @view.display_success("Project '#{project_name}' deleted successfully")
  end

  private

  def save_project(project)
    if project.valid?
      project.save
      @view.display_success("Project '#{project.name}' created successfully")
    else
      @view.display_error("Could not create project '#{project.name}': #{project.errors.full_messages.join(', ')}")
    end
  end
end

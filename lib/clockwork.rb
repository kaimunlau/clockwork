# frozen_string_literal: true

# This file is the entry point for the program

require 'sequel'
db_path = File.expand_path('../db/database.db', __dir__)
DB = Sequel.sqlite(db_path)
require_relative 'models/project'
require_relative 'models/session'
require_relative 'controllers/projects_controller'
require_relative 'controllers/sessions_controller'
require_relative 'option_parser'
require_relative 'view'
require_relative 'router'

# Parse options from command line
options = OptionParser.parse(ARGV)

# Create a new view
view = View.new

# Create controllers
projects_controller = ProjectsController.new(view)
sessions_controller = SessionsController.new(view)

# Execute program using controller and passing options
router = Router.new(options, view, projects_controller, sessions_controller)
view.frame('Clock Work ⏰', :box, :magenta) { router.execute }

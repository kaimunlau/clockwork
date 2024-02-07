# frozen_string_literal: true

# This file is the entry point for the program

require 'sequel'
DB = Sequel.sqlite('db/database.db')
require_relative 'models/project'
require_relative 'models/session'
require_relative 'option_parser'
require_relative 'view'
require_relative 'router'

# Parse options from command line
options = OptionParser.parse(ARGV)

# Create a new view
view = View.new

# Execute program using controller and passing options
router = Router.new(options, view)
router.execute

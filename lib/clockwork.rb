# frozen_string_literal: true

# This file is the entry point for the program

require_relative 'option_parser'
require_relative 'controller'

# Parse options from command line
options = OptionParser.parse(ARGV)

# Execute program using controller and passing options
controller = Controller.new(options)
controller.execute

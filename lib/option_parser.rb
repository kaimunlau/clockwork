# frozen_string_literal: true

require 'optparse'

# This class is responsible for parsing the options given to the program.
class OptionParser
  def self.parse(args)
    options = {}
    opts = OptionParser.new

    configure_banner(opts)
    add_options(opts, options)
    add_help_option(opts)

    opts.parse!(args)
    options
  end

  def self.configure_banner(opts)
    opts.banner = 'Usage: run clockwork.rb [OPTION]'
  end

  def self.add_options(opts, options)
    add_new_option(opts, options)
    add_start_option(opts, options)
    add_pause_option(opts, options)
    add_total_option(opts, options)
    add_list_option(opts, options)
    add_delete_option(opts, options)
  end

  def self.add_new_option(opts, options)
    opts.on('-n', '--new', 'Add a new project and start the clock') do
      options[:new] = true
    end
  end

  def self.add_start_option(opts, options)
    opts.on('-s', '--start [PROJECT]', 'Start the clock') do |s|
      options[:start] = s || ''
    end
  end

  def self.add_pause_option(opts, options)
    opts.on('-p', '--pause', 'Pause the clock') do
      options[:pause] = true
    end
  end

  def self.add_total_option(opts, options)
    opts.on('-t', '--total [PROJECT]', 'Total time worked') do |t|
      options[:total] = t || ''
    end
  end

  def self.add_list_option(opts, options)
    opts.on('-l', '--list', 'List all projects') do
      options[:list] = true
    end
  end

  def self.add_delete_option(opts, options)
    opts.on('-d', '--delete [PROJECT]', 'Delete project') do |d|
      options[:delete] = d || ''
    end
  end

  def self.add_help_option(opts)
    opts.on_tail('-h', '--help', 'Show this message') do
      puts opts
      exit
    end
  end
end

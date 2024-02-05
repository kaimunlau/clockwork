# frozen_string_literal: true

require 'rspec'
require_relative '../lib/option_parser'

RSpec.describe 'OptionParser' do
  describe '.parse' do
    it 'parses the options given to the program' do
      ARGV.replace %w[--new --start --pause --total --list --delete]
      options = OptionParser.parse(ARGV)
      expect(options[:new]).to eq(true)
      expect(options[:start]).to eq('')
      expect(options[:pause]).to eq(true)
      expect(options[:total]).to eq('')
      expect(options[:list]).to eq(true)
      expect(options[:delete]).to eq('')
    end

    it 'parses the option shorthands given to the program' do
      ARGV.replace %w[-n -s -p -t -l -d]
      options = OptionParser.parse(ARGV)
      expect(options[:new]).to eq(true)
      expect(options[:start]).to eq('')
      expect(options[:pause]).to eq(true)
      expect(options[:total]).to eq('')
      expect(options[:list]).to eq(true)
      expect(options[:delete]).to eq('')
    end

    it 'parses the project name when given' do
      ARGV.replace %w[--start Project]
      options = OptionParser.parse(ARGV)
      expect(options[:start]).to eq('Project')

      ARGV.replace %w[--total Project]
      options = OptionParser.parse(ARGV)
      expect(options[:total]).to eq('Project')

      ARGV.replace %w[--delete Project]
      options = OptionParser.parse(ARGV)
      expect(options[:delete]).to eq('Project')
    end
  end
end

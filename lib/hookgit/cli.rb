require 'rake'
require 'thor'
require 'hookgit/setup'

module Hookgit
  class CLI < Thor
    desc "setup", "Setup the .githooks directory"
    def setup
      Hookgit::Setup.install
      puts ".githooks directories created."
    end

    desc "enable", "Enable git hooks"
    def enable
      Hookgit::Setup.enable_hooks
      puts "Git hooks enabled."
    end

    desc "disable", "Disable git hooks"
    def disable
      Hookgit::Setup.disable_hooks
      puts "Git hooks disabled."
    end

    desc "run HOOK_NAME", "Run tasks for the given hook."
    def run_hook(hook_name)
      Rake.application.init
      Rake.application.load_rakefile
      task_files = Dir.glob(".githooks/tasks/*.rake").select { |file| File.read(file).include?("namespace :#{hook_name.gsub('-', '_')}") }
      task_files.each { |file| Rake.load_rakefile(file) }
      Rake.application["#{hook_name.gsub('-', '_')}:run"].invoke
    end
  end
end
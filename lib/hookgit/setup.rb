module Hookgit
  class Setup
    HOOKS = %w[applypatch-msg commit-msg fsmonitor-watchman post-update pre-applypatch pre-commit pre-merge-commit pre-push pre-rebase pre-receive prepare-commit-msg update]

    def self.install
      create_directories
      remove_sample_hooks
    end

    def self.create_directories
      Dir.mkdir('.githooks') unless Dir.exist?('.githooks')
      Dir.mkdir('.githooks/tasks') unless Dir.exist?('.githooks/tasks')
    end

    def self.remove_sample_hooks
      dir_path = File.join('.git', 'hooks')
      Dir.foreach(dir_path) do |f|
        fn = File.join(dir_path, f)
        File.delete(fn) if f != '.' && f != '..'
      end
    end

    def self.enable_hooks
      unless Dir.exist?('.git')
        puts 'initialise git before enabling git hooks'
      else
        HOOKS.each do |hook|
          hook_path = File.join('.git', 'hooks', hook)
          File.open(hook_path, 'w') do |file|
            file.write("#!/bin/bash\n")
            file.write("bin/hookgit run #{hook} || exit 1\n")
          end
          File.chmod(0755, hook_path)
        end
      end
    end

    def self.disable_hooks
      unless Dir.exist?('.git')
        puts 'initialise git before enabling git hooks'
      else
        HOOKS.each do |hook|
          hook_path = File.join('.git', 'hooks', hook)
          File.delete(hook_path) if File.exist?(hook_path)
        end
      end
    end
  end
end

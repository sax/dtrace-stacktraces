require "bundler/gem_tasks"
require "rake/extensiontask"

namespace :ext do
  desc 'make clean in extensions'
  task :clean do
    Dir.chdir('ext/dtrace/stacktraces') do
      sh('make clean || true')
      sh('rm -f Makefile *.a *.h')
    end
  end
end

task :release => 'ext:clean'

Rake::ExtensionTask.new "ruby_ustack" do |ext|
  ext.ext_dir = 'ext/dtrace/stacktraces'
  ext.lib_dir = "ext/dtrace/stacktraces"
end

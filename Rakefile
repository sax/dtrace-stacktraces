require "bundler/gem_tasks"

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

task :compile => 'ext:clean' do
  sh %{
cd ext/dtrace/stacktraces
ruby extconf.rb
make
  }
end


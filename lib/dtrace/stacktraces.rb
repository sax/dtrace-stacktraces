require 'dtrace/stacktraces/version'
require 'dtrace/stacktraces/ruby_ustack'

module Dtrace
  module Stacktraces
    # Your code goes here...
  end
end

ustack_helper = File.expand_path('../../../ext/dtrace/stacktraces/ruby_dtrace_ustack.d', __FILE__)

# TODO ustack_helper needs to be real absolute path to file
puts "rubyland: I am trying to load #{ustack_helper}"
RubyUstack.load_ustack_helper(ustack_helper)

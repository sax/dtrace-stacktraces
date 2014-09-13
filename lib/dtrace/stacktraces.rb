require 'dtrace/stacktraces/version'
require 'dtrace/stacktraces/ruby_ustack'

module Dtrace
  module Stacktraces
    # Your code goes here...
  end
end

ustack_helper = File.join(File.expand_path('../../..', __FILE__), 'ext/dtrace/stacktraces/ruby_dtrace_ustack.d')
puts ustack_helper
# TODO ustack_helper needs to be real absolute path to file
RubyUstack.load_ustack_helper(ustack_helper)

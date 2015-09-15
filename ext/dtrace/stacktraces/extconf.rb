require 'mkmf'

def development?
  !!ENV['OLDPWD']
end

if have_library('dtrace', 'dtrace_open', '/usr/include/dtrace.h')
  # system('cp $OLDPWD/ruby_dtrace_ustack.d .') if development?

  d_script = File.expand_path('../ruby_dtrace_ustack.d', __FILE__)
  d_header = File.expand_path('../ruby_dtrace_ustack.h', __FILE__)

  abort 'Unable to export dtrace headers' unless system('/usr/sbin/dtrace -h -s %s' % d_script)
  # abort 'Unable to create headers from dtrace ustack helper' unless have_header(d_header)
  abort 'Unable to compile dtrace script' unless system('/usr/sbin/dtrace -64 -C -G -s %s' % d_script)

  # system('cp ruby_dtrace_ustack.{h,o} $OLDPWD') if development?
  create_makefile('ruby_ustack')
end


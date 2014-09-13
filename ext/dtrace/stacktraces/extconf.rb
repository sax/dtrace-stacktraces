require 'mkmf'

def development?
  !!ENV['OLDPWD']
end

if have_library("dtrace", "dtrace_open", "/usr/include/dtrace.h")
  system('cp $OLDPWD/ruby_dtrace_ustack.d .') if development?

  system('dtrace -h -s ruby_dtrace_ustack.d')
  system('dtrace -64 -C -G -s ruby_dtrace_ustack.d')

  system('cp ruby_dtrace_ustack.{h,o} $OLDPWD') if development?
  create_makefile('ruby_ustack')
end


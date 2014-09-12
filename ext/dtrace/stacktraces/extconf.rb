require 'mkmf'

def development?
  !!ENV['OLDPWD']
end

if have_library("dtrace", "dtrace_open", "/usr/include/dtrace.h")
  system('cp $OLDPWD/ruby_ustack.d .') if development?

  system('dtrace -h -o ruby_ustack.h -s ruby_ustack.d')

  system('cp ruby_ustack.h $OLDPWD') if development?
  create_makefile('ruby_ustack')
end


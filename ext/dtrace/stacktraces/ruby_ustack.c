#include <ruby.h>
#include "ruby_dtrace_ustack.h"
#include <dtrace.h>
#include <fcntl.h>

static VALUE RubyUstack;

void Init_ruby_ustack();
static VALUE load_ustack_helper(VALUE *path);

void Init_ruby_ustack()
{
  RubyUstack = rb_define_module("RubyUstack");
  rb_define_singleton_method(RubyUstack, "load_ustack_helper", load_ustack_helper, 1);
}


static const char *helper = "/dev/dtrace/helper";

static int load_dof_helper(int fd, dof_helper_t *dh) {
  return ioctl(fd, DTRACEHIOC_ADDDOF, dh);
}

static int load_dof(dof_hdr_t *dof) {
  dof_helper_t dh;
  int fd;
  int gen;

  dh.dofhp_dof  = (uintptr_t)dof;
  dh.dofhp_addr = (uintptr_t)dof;
  (void) strncpy(dh.dofhp_mod, "ruby", sizeof (dh.dofhp_mod));

  if ((fd = open(helper, O_RDWR)) < 0)
    return (-1);

  gen = load_dof_helper(fd, &dh);

  if ((close(fd)) < 0)
    return (-1);

  if (gen < 0)
    return (-1);

  return (0);
}

static VALUE load_ustack_helper(VALUE *path) {
  dtrace_hdl_t *dtp;
  dtrace_prog_t *helper;
  int err;
  void *dof;
  FILE *fp;
  int argc = 8;
  char *argv[8] = { "ruby" };

  // TODO convert path to char
  if ((fp = fopen(RSTRING_PTR(path), "r")) == NULL)
		rb_raise(rb_eFatal, "failed to open %s", path);

  dtp = dtrace_open(DTRACE_VERSION, DTRACE_O_NODEV, &err);
  if (dtp == NULL) {
    dtrace_close(dtp);
    rb_raise(rb_eFatal, "dtrace_open failed: %s", dtrace_errmsg(dtp, err));
  }

  (void) dtrace_setopt(dtp, "linkmode", "dynamic");
  (void) dtrace_setopt(dtp, "unodefs", NULL);

  if ((helper = dtrace_program_fcompile(dtp, fp,
          DTRACE_C_CPP | DTRACE_C_ZDEFS,
          argc, argv)) == NULL) {
    dtrace_close(dtp);
    rb_raise(rb_eFatal, "compile failed: %s", dtrace_errmsg(dtp, dtrace_errno(dtp)));
  }

  (void) fclose(fp);

  if ((dof = dtrace_dof_create(dtp, helper, 0)) == NULL) {
    dtrace_close(dtp);
    rb_raise(rb_eFatal, "DOF create failed: %s", dtrace_errmsg(dtp, dtrace_errno(dtp)));
  }

  if (load_dof(dof) != 0) {
    dtrace_close(dtp);
    rb_raise(rb_eFatal, "DOF load failed: %s", strerror(err));
  }

  dtrace_close(dtp);

  return Qnil;
}

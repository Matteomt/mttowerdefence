class _error {
  int level=1;
  String msg="Unknown error.";
  _error(int l) {
    this.level=l;
    if (l==0)this.msg="[no catched errors]";
  }
  _error() {
    this.level=0;
    this.msg="[no catched errors]";
  }
  _error(int l, String m) {
    this.level=l;
    this.msg=m;
  }
}



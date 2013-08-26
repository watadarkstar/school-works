int wain(int a, int b) {
  int t = 00;
  while (b != 0) {
    t = b;
    b = a % b;
    a = t;
  }
  return a ;
}


double toNaiveDouble2digit(double x){
// [2.0, 2.0]
// [0.404, 0.4]
// [1.505, 1.5] naive because 1.505 shoulb be rounded to 1.51 and not 1.5
// [3.606, 3.61]
// [4.917, 4.92]
    return num.parse(x.toStringAsFixed(2));
  }

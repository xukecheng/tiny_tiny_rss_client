import '../Tool/SizeCalculate.dart';

extension IntFit on int {
  double get px {
    return SizeCalculate.setPx(this.toDouble());
  }

  double get rpx {
    return SizeCalculate.setRpx(this.toDouble());
  }
}

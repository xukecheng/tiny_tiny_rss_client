import '../Tool/SizeCalculate.dart';

extension DoubleFit on double {
  double get px {
    return SizeCalculate.setPx(this);
  }

  double get rpx {
    return SizeCalculate.setRpx(this);
  }
}

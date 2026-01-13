/// Uyku verisini temsil eden model.
class SleepData {
  /// Toplam uyku süresi (dakika cinsinden).
  final double durationMinutes;

  /// Uyku kalitesi skoru (0.0 - 1.0 arası).
  final double qualityScore;

  /// Uykunun başladığı zaman.
  final DateTime startTime;

  /// Uykunun bittiği zaman.
  final DateTime endTime;

  const SleepData({
    required this.durationMinutes,
    required this.qualityScore,
    required this.startTime,
    required this.endTime,
  });

  /// Uyku süresi 5 saatten az mı?
  bool get isLow => durationMinutes < 300;

  /// Uyku süresi 7 saatten fazla mı?
  bool get isOptimal => durationMinutes >= 420;
}

/// Stres seviyesini temsil eden model.
class StressLevel {
  /// Stres skoru (0.0 - 1.0 arası). 1.0 = maksimum stres.
  final double score;

  /// HRV (Heart Rate Variability) değeri (mevcutsa).
  final double? hrv;

  /// Ölçüm zamanı.
  final DateTime timestamp;

  const StressLevel({required this.score, this.hrv, required this.timestamp});

  /// Stres yüksek mi? (0.7 üzeri)
  bool get isHigh => score > 0.7;

  /// Stres ortalama mı? (0.4 - 0.7 arası)
  bool get isMedium => score >= 0.4 && score <= 0.7;

  /// Stres düşük mü? (0.4 altı)
  bool get isLow => score < 0.4;
}

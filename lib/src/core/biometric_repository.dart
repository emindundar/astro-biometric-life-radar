import 'models/biometric_data.dart';

/// Biyometrik veri sağlayıcıları için soyut arayüz (interface).
///
/// Bu arayüz, farklı veri kaynaklarından (HealthKit, Google Fit veya
/// manuel giriş) biyometrik verileri almak için ortak bir sözleşme tanımlar.
///
/// **Implementation A**: [HealthKitRepository] - Gerçek wearable verisi
/// **Implementation B**: [ManualInputRepository] - Gamified kullanıcı girişi
abstract class BiometricRepository {
  /// Belirli bir tarih için uyku verisini getirir.
  ///
  /// [date] parametresi, hangi günün uyku verisinin isteneceğini belirtir.
  /// Veri bulunamazsa `null` döner.
  Future<SleepData?> getSleepData(DateTime date);

  /// Mevcut stres seviyesini getirir.
  ///
  /// Gerçek zamanlı HRV verisi veya kullanıcı girişine dayalı
  /// tahmini stres seviyesi döner.
  /// Veri bulunamazsa `null` döner.
  Future<StressLevel?> getStressLevel();

  /// Kullanıcının biyometrik veri kaynağı olup olmadığını kontrol eder.
  ///
  /// `true` dönerse gerçek veri (HealthKit/Google Fit) mevcuttur.
  /// `false` dönerse manuel/gamified giriş gereklidir.
  Future<bool> hasDataSource();

  /// Veri kaynağına erişim izni alır.
  ///
  /// İzin verilirse `true`, reddedilirse `false` döner.
  Future<bool> requestPermissions();
}

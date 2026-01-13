import '../../../core/biometric_repository.dart';
import '../../../core/models/biometric_data.dart';

/// Akıllı saati olmayan kullanıcılar için "Gamified Input" stratejisini
/// uygulayan repository implementasyonu.
///
/// Bu sınıf, kullanıcıdan doğrudan veri almak yerine oyunlaştırılmış
/// yöntemlerle (Tarot kartları, validation loop) veri "çalar".
///
/// **Yöntem 1**: Tersine Mühendislik - Tahmin yap, kullanıcı doğrulasın
/// **Yöntem 2**: Kart Seçimi - Seçilen karttan ruh hali çıkar
class ManualInputRepository implements BiometricRepository {
  // Kullanıcının son girdiği/seçtiği veriler
  SleepData? _lastSleepData;
  StressLevel? _lastStressLevel;

  // Kullanıcının seçtiği kart arketipi -> Stres mapping
  static const Map<String, double> _archetypeStressMap = {
    'yorgun_gezgin': 0.75, // Yüksek stres, düşük enerji
    'savas_tanrisi': 0.85, // Çok yüksek stres, agresif
    'huzurlu_bilge': 0.25, // Düşük stres, sakin
    'maceraci_ruh': 0.45, // Orta stres, enerjik
    'melankolik_sanatci': 0.65, // Orta-yüksek stres, duygusal
    'neseli_cocuk': 0.20, // Çok düşük stres, mutlu
  };

  @override
  Future<bool> hasDataSource() async {
    // Manuel giriş her zaman mümkün
    return true;
  }

  @override
  Future<bool> requestPermissions() async {
    // Manuel giriş için izin gerekmez
    return true;
  }

  @override
  Future<SleepData?> getSleepData(DateTime date) async {
    // Kullanıcıdan daha önce giriş alınmışsa onu döndür
    if (_lastSleepData != null) {
      return _lastSleepData;
    }

    // Henüz giriş yoksa null dön
    // UI katmanı validation loop başlatmalı
    return null;
  }

  @override
  Future<StressLevel?> getStressLevel() async {
    // Kullanıcıdan daha önce giriş alınmışsa onu döndür
    if (_lastStressLevel != null) {
      return _lastStressLevel;
    }

    // Henüz giriş yoksa null dön
    // UI katmanı kart seçimi göstermeli
    return null;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // GAMIFIED INPUT METHODS
  // ─────────────────────────────────────────────────────────────────────────

  /// **Yöntem 1: Validation Loop**
  ///
  /// Kullanıcıya tahmin sunulur: "Yataktan çıkmak istemiyor gibisin?"
  /// Kullanıcı "Aynen Öyle" veya "Hayır, Bomba Gibiyim" der.
  ///
  /// [confirmed] = true ise tahmin doğrulandı (düşük enerji/uyku).
  /// [confirmed] = false ise kullanıcı iyi durumda.
  void validateSleepPrediction({required bool confirmed}) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    if (confirmed) {
      // Kullanıcı tahmini doğruladı = Kötü uyku
      _lastSleepData = SleepData(
        durationMinutes: 270, // ~4.5 saat (düşük)
        qualityScore: 0.35,
        startTime: DateTime(
          yesterday.year,
          yesterday.month,
          yesterday.day,
          2,
          0,
        ),
        endTime: DateTime(now.year, now.month, now.day, 6, 30),
      );
    } else {
      // Kullanıcı tahmini reddetti = İyi uyku
      _lastSleepData = SleepData(
        durationMinutes: 480, // 8 saat (optimal)
        qualityScore: 0.85,
        startTime: DateTime(
          yesterday.year,
          yesterday.month,
          yesterday.day,
          23,
          0,
        ),
        endTime: DateTime(now.year, now.month, now.day, 7, 0),
      );
    }
  }

  /// **Yöntem 2: Tarot/Kart Seçimi**
  ///
  /// Kullanıcı 3 karttan birini seçer. Her kartın arkasında bir "arketip" var.
  /// Bu arketip, sistemde stres/enerji seviyesine dönüştürülür.
  ///
  /// [archetype] değerleri:
  /// - `yorgun_gezgin`: Düşük enerji, yüksek stres
  /// - `savas_tanrisi`: Agresif enerji, çok yüksek stres
  /// - `huzurlu_bilge`: Sakin, düşük stres
  /// - `maceraci_ruh`: Enerjik, orta stres
  /// - `melankolik_sanatci`: Duygusal, orta-yüksek stres
  /// - `neseli_cocuk`: Mutlu, çok düşük stres
  void selectCard(String archetype) {
    final stressScore = _archetypeStressMap[archetype] ?? 0.5;

    _lastStressLevel = StressLevel(
      score: stressScore,
      hrv: null, // Manuel girişte HRV yok
      timestamp: DateTime.now(),
    );
  }

  /// Tüm manuel girişleri temizler (yeni gün için reset).
  void clearInputs() {
    _lastSleepData = null;
    _lastStressLevel = null;
  }
}

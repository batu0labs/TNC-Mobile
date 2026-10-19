# Mini Katalog Uygulaması

## Proje Özeti

- **Proje adı:** Mini Katalog Uygulaması
- **Kısa açıklama:** Flutter ve Dart ile geliştirilmiş bir Android ürün katalog uygulamasıdır. Ürünleri yerel JSON dosyasından yükler, iki sütunlu bir grid içinde listeler, arama/filtreleme yapılmasına ve ürün detaylarının görüntülenmesine olanak tanır.
- **Kullanılan Flutter sürümü:** Kaynak README'de kesin sürüm numarası belirtilmemiştir. Geliştirme ortamındaki sürümü `flutter --version` komutuyla kontrol edip bu satırı gerçek sürüm numarasıyla güncelleyin.

## Hızlı Başlangıç

### Gereksinimler

- Flutter SDK ve Dart SDK
- Android Studio ile Android SDK
- Android Emulator veya USB hata ayıklaması etkin bir Android cihaz

### Çalıştırma

1. Proje klasörünü açın ve terminalde proje kök dizinine geçin (`pubspec.yaml` dosyasının bulunduğu dizin).
2. Flutter kurulumunu kontrol edin:

   ```bash
   flutter doctor -v
   ```

3. Proje bağımlılıklarını yükleyin:

   ```bash
   flutter pub get
   ```

4. Bir Android emülatörü başlatın veya Android cihazınızı bağlayın.
5. Uygulamayı derleyip çalıştırın:

   ```bash
   flutter run
   ```

İsteğe bağlı olarak kod analizi ve testleri çalıştırabilirsiniz:

```bash
flutter analyze
flutter test
```

## 1. Proje Hakkında

**Mini Katalog**, Flutter ve Dart kullanılarak geliştirilmiş temel seviyede bir Android katalog uygulamasıdır. Projenin amacı; Flutter widget yapısını, sayfa düzenlemeyi, ürün verilerini modellemeyi, JSON dosyasından veri okumayı, dinamik listeleme yapmayı ve sayfalar arasında veri aktarmayı uygulamalı olarak öğrenmektir.

Uygulama, ürünleri iki sütunlu bir katalog ekranında gösterir. Kullanıcı ürünler arasında arama yapabilir ve bir ürünü seçerek ayrıntılarını görüntüleyebilir.

> **Kapsam notu:** Bu sürümde çalışan bir sepet sistemi bulunmamaktadır. Ürün miktarı, sepet toplamı, ürün silme veya sipariş oluşturma işlevleri uygulanmamıştır. Ürün detay ekranında “Sepete Ekle” butonu bulunuyorsa bu buton yalnızca eğitim amaçlı bir bilgilendirme mesajı gösterir; ürünleri bir sepete kaydetmez.

## 2. Kullanılan Teknolojiler ve Araçlar

- **Flutter SDK:** Mobil uygulamanın arayüzü ve uygulama yapısı.
- **Dart:** Uygulama kodlarının yazıldığı programlama dili.
- **Visual Studio Code:** Kod geliştirme ortamı.
- **Android Studio / Android Emulator:** Android SDK bileşenlerini ve sanal cihazı yönetmek, uygulamayı test etmek için.
- **Material widget'ları:** `MaterialApp`, `Scaffold`, `AppBar`, `Card`, `TextField`, `GridView`, `ElevatedButton` ve benzeri arayüz bileşenleri.
- **Dart JSON araçları:** `dart:convert` içindeki `jsonDecode()` ile JSON metnini Dart veri yapılarına dönüştürme.
- **Flutter asset sistemi:** Yerel JSON ve banner dosyasını uygulamaya dahil etme.

Bu projede Provider, Riverpod, Bloc veya benzeri ek bir durum yönetimi paketi kullanılmamaktadır. Ürün listesi ekranında yerel widget durumu için `StatefulWidget` ve `setState()` yaklaşımından yararlanılır.

## 3. Uygulamanın Mevcut Özellikleri

### 3.1 Ana Sayfa

Ana sayfa uygulamanın giriş ekranıdır. Ekranda uygulama başlığı, yerel asset olarak eklenmiş banner görseli, katalog hakkında kısa bir açıklama ve ürün listesine geçiş sağlayan bir buton bulunur.

Banner dosyası `Image.asset()` ile gösterilir. Görsel yüklenemediğinde `errorBuilder` üzerinden alternatif bir arayüz gösterilerek sayfanın kullanılamaz hâle gelmesi engellenir.

“Ürünleri Gör” butonu, Navigator üzerinden ürün listesi rotasına geçiş yapar.

### 3.2 Ürün Listesi

Ürün listesi, JSON dosyasından okunan verileri ürün kartlarına dönüştürür. Liste iki sütunlu bir `GridView.builder` ile gösterilir.

Her ürün kartında genel olarak şu bilgiler yer alır:

- Ürün görseli
- Ürün adı
- Kısa açıklama (`tagline`, varsa)
- Ürün fiyatı
- Ürün detayına geçişi belirten ikon

`GridView.builder`, öğeleri ihtiyaç oldukça oluşturur. Böylece bütün kartların arayüzünü tek tek elle yazmak gerekmez. Kart görünümü `ProductCard` adlı ayrı bir widget'ta tutulduğu için aynı tasarım birden fazla ürün için yeniden kullanılabilir.

Ürün görselleri JSON içerisinde bulunan URL'ler üzerinden `Image.network()` ile yüklenir. Yüklenme sırasında bir gösterge; hata oluştuğunda ise görsel yerine bir ikon gösterilebilir.

### 3.3 Ürün Arama ve Filtreleme

Ürün listesi ekranında bulunan `TextField`, kullanıcının arama metnini alır. Metin değiştiğinde `onChanged` callback'i çalışır ve `_query` değeri `setState()` ile güncellenir.

Filtreleme; ürünün adı, kısa açıklaması ve ayrıntılı açıklaması üzerinde yapılır. Arama öncesinde metin küçük harfe dönüştürülür ve Türkçe karakterler için basit bir normalizasyon uygulanır. Eşleşen ürünler yeni bir listeye alınarak grid içerisinde gösterilir.

Arama kutusundaki temizleme ikonu metni sıfırlar. Hiçbir ürün eşleşmediğinde boş sonuç mesajı gösterilir.

### 3.4 Ürün Detay Sayfası

Kullanıcı ürün kartına bastığında seçilen ürüne ait detay ekranı açılır. Ekranda şu bilgiler bulunabilir:

- Ürün adı
- Ürün görseli
- Kısa açıklama
- Fiyat
- Ayrıntılı ürün açıklaması
- Teknik özellikler

Teknik özellikler `specs` isimli dinamik bir haritadan okunur. Her ürünün özellik anahtarları aynı olmak zorunda olmadığı için alanlar tek tek sabit kodlanmaz; mevcut `specs` girdileri döngüyle ekrana yazılır.

Sayfanın gövdesinde `SingleChildScrollView` kullanılması, uzun açıklamaların ve çok sayıda teknik özelliğin kaydırılarak okunmasını sağlar.

**Sepet durumu:** Bu sürümde detay sayfasındaki “Sepete Ekle” butonu, uygulanmış bir sepet veri yapısına bağlı değildir. Mevcut taslak kodda buton yalnızca sepet işlevinin daha sonra ekleneceğini bildiren bir `SnackBar` gösterebilir.

## 4. Proje Klasör Yapısı

Projenin ilgili dosyaları aşağıdaki yapıda düzenlenmiştir:

```text
mini_katalog/
├── assets/
│   ├── data/
│   │   └── products.json
│   └── images/
│       └── banner.png
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── product.dart
│   ├── data/
│   │   └── product_repository.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── product_list_screen.dart
│   │   └── product_detail_screen.dart
│   └── widgets/
│       └── product_card.dart
├── test/
│   └── widget_test.dart
└── pubspec.yaml
```

### Dosyaların Sorumlulukları

| Dosya | Sorumluluk |
|---|---|
| `main.dart` | Uygulamayı başlatır, temayı tanımlar ve sayfa rotalarını yapılandırır. |
| `models/product.dart` | Ürünün Dart veri modelini ve JSON dönüşümlerini tanımlar. |
| `data/product_repository.dart` | Asset içerisindeki JSON dosyasını okur ve `Product` listesi üretir. |
| `screens/home_screen.dart` | Banner ve ürün listesine geçiş butonunu gösterir. |
| `screens/product_list_screen.dart` | Ürün verisini yükler, arama/filtreleme yapar ve ürünleri grid olarak gösterir. |
| `screens/product_detail_screen.dart` | Seçilen ürünün ayrıntılarını gösterir. |
| `widgets/product_card.dart` | Tek bir ürünün katalog kartını oluşturur. |
| `assets/data/products.json` | Ürün verilerinin yerel kopyasını tutar. |
| `assets/images/banner.png` | Ana sayfada kullanılan banner görselini tutar. |
| `test/widget_test.dart` | Ana sayfanın temel bileşenlerini kontrol eden widget testini içerir. |
| `pubspec.yaml` | Proje paket ayarlarını ve asset dosyalarını tanımlar. |

## 5. Veri Modeli

`Product` modeli, JSON dosyasındaki ürün nesnesini uygulamanın diğer katmanlarında kullanılabilecek Dart nesnesine dönüştürür.

Modelde kullanılan başlıca alanlar:

| Alan | Tip | Açıklama |
|---|---|---|
| `id` | `int` | Ürünün benzersiz kimliği. |
| `name` | `String` | Ürün adı. |
| `tagline` | `String` | Ürünün kısa açıklaması. |
| `description` | `String` | Ayrıntılı ürün açıklaması. |
| `price` | `String` | Veri kaynağından gelen fiyat metni. |
| `currency` | `String` | Para birimi bilgisi. |
| `image` | `String` | Ürün görselinin URL'si. |
| `specs` | `Map<String, dynamic>` | Ürüne göre değişebilen teknik özellikler. |

`Product.fromJson()` JSON'dan gelen haritayı `Product` nesnesine dönüştürür. `Product.toJson()` ise nesneyi yeniden harita yapısına çevirir.

`price` alanının metin olarak tutulmasının nedeni veri kaynağının fiyatı örneğin `"$999"` biçiminde döndürmesidir. Bu sürümde fiyatlar yalnızca ekranda gösterilir; sepet veya ödeme hesabı yapılmaz.

## 6. Veri Kaynağı ve JSON Okuma Süreci

Eğitimde kullanılan örnek kaynaklar:

- Ürün verileri: <https://wantapi.com/products.php>
- Banner görseli: <https://wantapi.com/assets/banner.png>

Bu sürümde kaynaklardan indirilen dosyalar proje içine yerel asset olarak eklenir:

- `assets/data/products.json`
- `assets/images/banner.png`

Uygulama çalışırken ürün listesini canlı API üzerinden istemek yerine `products.json` dosyasını okur. Dolayısıyla ağdan alınan verinin otomatik güncellenmesi beklenmez; JSON dosyası yenilenirse proje dosyasının da güncellenmesi gerekir.

`ProductRepository.loadProducts()` işleminin genel akışı şöyledir:

1. `rootBundle.loadString()` ile JSON asset'i okunur.
2. `jsonDecode()` ile JSON metni Dart nesnelerine çevrilir.
3. Ürün dizisi JSON'un üst seviyesindeki `data` alanından alınır.
4. Her dizi elemanı `Product.fromJson()` ile `Product` nesnesine çevrilir.
5. Sonuç `Future<List<Product>>` olarak ekran katmanına döndürülür.

`ProductListScreen`, bu asenkron işlemi `FutureBuilder<List<Product>>` ile yönetir. Veri yüklenirken ilerleme göstergesi; hata durumunda hata mesajı ve tekrar deneme seçeneği; veri geldiğinde ürün grid'i gösterilir.

## 7. Sayfa Geçişleri ve Veri Aktarımı

Sayfalar arası navigasyon Flutter'ın yerleşik `Navigator` mekanizmasıyla yapılır.

### Ana sayfadan ürün listesine

Ana sayfadaki buton `Navigator.pushNamed()` ile ürün listesi rotasını açar. Rota `main.dart` içerisinde tanımlanır.

### Ürün listesinden ürün detayına

Kullanıcı bir `ProductCard` üzerine bastığında seçilen `Product` nesnesi, detay rotasına `arguments` parametresiyle gönderilir.

`main.dart` içindeki `onGenerateRoute`, gelen argümanın `Product` türünde olup olmadığını kontrol eder. Geçerliyse `ProductDetailScreen` oluşturulur ve seçilen ürün doğrudan sayfaya aktarılır. Böylece detay ekranının ürünü bulmak için JSON dosyasını yeniden okuması gerekmez.

Bu düzen; named route, `MaterialPageRoute`, route arguments ve sayfalar arasında veri aktarımı konularını örnekler.

## 8. Kurulum ve Çalıştırma

### Gereksinimler

- Flutter SDK
- Dart SDK (Flutter kurulumu ile birlikte gelir)
- Visual Studio Code ve Flutter eklentisi
- Android Studio ve Android SDK
- Çalışan bir Android Emulator veya USB hata ayıklaması etkin fiziksel Android cihaz

### Kurulum adımları

1. Proje klasörünü VS Code ile aç ve terminalde `pubspec.yaml` dosyasının bulunduğu kök dizine gel.
2. `pubspec.yaml` dosyasında asset tanımlarının bulunduğunu doğrula.
3. Aşağıdaki komutları sırayla çalıştır:

```bash
flutter doctor -v
flutter pub get
flutter run
```

Uygulama çalıştıktan sonra isteğe bağlı doğrulama için şu komutları kullanabilirsin:

```bash
dart format lib test
flutter analyze
flutter test
```

`flutter doctor -v`, geliştirme ortamındaki eksikleri kontrol etmeye yardımcı olur. `flutter pub get`, proje bağımlılıklarını hazırlar ve `flutter run` uygulamayı bağlı cihaza yükleyip başlatır. `dart format`, Dart dosyalarını biçimlendirir; `flutter analyze` statik analiz yapar ve `flutter test` testleri çalıştırır.

### Asset ayarları

`pubspec.yaml` içerisindeki `flutter` bölümünde şu dosyaların tanımlandığından emin ol:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/data/products.json
    - assets/images/banner.png
```

Girintilerin YAML formatına uygun olması gerekir. Asset yolu değişirse `pubspec.yaml` içindeki yol da güncellenmelidir.

## 9. Test Senaryoları

Uygulama tamamlandıktan sonra aşağıdaki senaryolar elle test edilmelidir:

1. Uygulama ana sayfada açılır.
2. Banner görseli görünür; görsel yüklenemezse hata ikonu gösterilir.
3. “Ürünleri Gör” butonu ürün listesi ekranını açar.
4. JSON içindeki ürünler kartlar halinde listelenir.
5. Kartların ürün adı, kısa açıklaması ve fiyatı doğru gösterilir.
6. Görseller yüklenirken ilerleme göstergesi görülür; görsel hatası uygulamayı çökertmez.
7. Arama alanı yazılan metne göre ürünleri filtreler.
8. Arama temizleme butonu tüm ürünleri yeniden gösterir.
9. Eşleşmeyen aramada boş sonuç mesajı görüntülenir.
10. Bir ürün seçildiğinde doğru ürünün detay ekranı açılır.
11. Detay ekranında ürün görseli, adı, fiyatı, açıklaması ve mevcut teknik özellikleri gösterilir.
12. Geri navigasyonla ürün listesine dönülebilir.
13. `flutter analyze` ve `flutter test` komutları çalıştırılır; varsa hatalar düzeltilir.

## 10. Bilinen Sınırlamalar

- Uygulama bir demo/katalog uygulamasıdır; gerçek e-ticaret altyapısı değildir.
- Ürünler yerel JSON dosyasından okunur; canlı API isteği ve otomatik veri yenileme yoktur.
- Kullanıcı hesabı, kimlik doğrulama, sipariş oluşturma ve ödeme işlemleri yoktur.
- **Sepet simülasyonu uygulanmamıştır.** Ürün ekleme, ürün adetini değiştirme, sepetten silme ve toplam tutar hesaplama işlevleri mevcut kapsamda bulunmaz.
- Fiyat alanı metin olarak tutulur; sayısal fiyat hesaplaması için ayrı bir para modeli ve doğrulanmış fiyat ayrıştırma mantığı gerekir.
- Ürün görselleri URL üzerinden yüklendiği için bunların gösterilmesi ağ erişimine ve URL'lerin çalışmasına bağlıdır.
- Basit arama normalizasyonu Türkçe karakterlerin yaygın biçimlerini ele alır; tam dilbilimsel arama veya gelişmiş filtreleme sağlamaz.
- Veriler cihazda kalıcı olarak değiştirilmiyor. Uygulama kapanıp açıldığında kullanıcı tarafından yapılmış bir sepet/alışveriş durumu bulunmaz.

## 11. Öğrenme Kazanımları

Bu proje ile aşağıdaki Flutter ve Dart konuları uygulamalı olarak ele alınmıştır:

- `StatelessWidget` ve `StatefulWidget` arasındaki fark
- Widget ağacı ve `BuildContext`
- `MaterialApp`, `Scaffold`, `AppBar` ve temel Material widget'ları
- `Row`, `Column`, `Padding`, `Expanded`, `Card` ve `GridView.builder`
- `TextField`, `onChanged` ve `setState()` ile arama durumu yönetimi
- Dart sınıfları, constructor'lar, `final`, listeler ve haritalar
- JSON çözümleme ve `fromJson` / `toJson` mantığı
- `Future`, `async` işlemler ve `FutureBuilder`
- Yerel asset yönetimi ve ağ üzerinden görsel gösterme
- `Navigator`, named routes, `MaterialPageRoute` ve route arguments
- Kodun model, veri katmanı, ekran ve yeniden kullanılabilir widget dosyalarına ayrılması
- `flutter analyze`, `flutter test` ve Android Emulator üzerinde uygulamayı test etme

## 12. Sonuç

Mini Katalog Uygulaması, Flutter kullanarak temel bir mobil uygulamanın baştan sona nasıl yapılandırılabileceğini gösteren eğitim amaçlı bir projedir. Ürün verisi ayrı bir model ve repository üzerinden yönetilir; katalog ekranı verileri grid yapısında gösterir; arama alanı listeyi dinamik olarak filtreler ve navigasyon aracılığıyla seçilen ürünün detaylarına erişilir.

Mevcut sürüm, ürün kataloglama ve sayfalar arası veri aktarma hedeflerini kapsar. 
# widgetFlip Gizlilik Politikası

**Son Güncelleme:** 27 Aralık 2025

## Genel Bakış

**widgetFlip**, sanal para atmanıza ve atım geçmişinizi görüntülemenize olanak tanıyan bir iOS uygulamasıdır. Gizliliğinize saygı duyuyor ve kişisel bilgilerinizi korumaya kararlıyız.

## Veri Toplama

**widgetFlip herhangi bir kişisel veri toplamaz, depolamaz veya aktarmaz.**

### Topladığımız Veriler
- Kişisel olarak tanımlanabilir bilgi (isim, e-posta, telefon numarası vb.) yok
- Cihaz tanımlayıcısı veya reklam tanımlayıcısı (IDFA, IDFV) yok
- Konum verisi yok
- Kullanım analitiği veya çökme raporu yok
- Üçüncü taraf analitik veya izleme hizmeti yok

## Yerel Veri Depolama

Uygulama aşadaki bilgileri Apple'ın UserDefaults framework'ünü kullanarak **sadece cihazınızda yerel olarak** depolar:

| Veri | Amaç | Konum |
|------|---------|----------|
| Mevcut para yüzü (YAZI/TURA) | Widget'ta göstermek | Yerel App Group deposu |
| Para ikonu adı | Widget'ta göstermek | Yerel App Group deposu |
| Son atım zaman damgası | Widget'ta göstermek | Yerel App Group deposu |
| Atım sayacı | Animasyon durumu | Yerel App Group deposu |
| Atım geçmişi (en fazla 50 kayıt) | Son atımları göstermek | Yerel App Group deposu |

Bu veriler:
- Asla cihazınızdan ayrılmaz
- Hiçbir üçüncü tarafla paylaşılmaz
- Cihazlar arasında senkronize edilmez
- Uygulamayı kaldırarak silinebilir

## App Group Kullanımı

widgetFlip, verileri aşağıdaki arasında paylaşmak için Apple'ın App Group özelliğini (`group.com.akinalpfdn.widgetflip`) kullanır:
- Ana uygulama
- Ana ekran widget'ı
- Kilit ekranı widget'ı/kontrol merkezi

Bu, widget'ın son para atım sonucunu göstermesini sağlar. Veriler cihazınızın dışına aktarılmaz.

## Ağ Etkinliği

**widgetFlip herhangi bir ağ isteği yapmaz.** Uygulama tamamen çevrimdışı çalışır ve internet bağlantısı gerektirmez.

## Üçüncü Taraf Hizmetler

**widgetFlip herhangi bir üçüncü taraf hizmet kullanmaz**, bunlar dahil ancak bunlarla sınırlı değildir:
- Analitik platformları (Google Analytics, Firebase vb.)
- Reklam ağları
- Sosyal medya entegrasyonları
- Bulut depolama hizmetleri

## Çocukların Gizliliği

Uygulama tüm yaşlar için uygundur ve 13 yaşın altındaki çocuklardan herhangi bir bilgi toplamaz.

## Bu Politikadaki Değişiklikler

Veri toplamadığımız için, bu gizlilik politikasının değişmesi muhtemel değildir. Veri toplayan özellikler eklersek, bu politikayı güncelleyecek ve sizi bilgilendireceğiz.

## İletişim

Bu gizlilik politikası veya uygulama hakkında sorularınız varsa, lütfen iletişime geçin:

**E-posta:** akinalpfdn@gmail.com
**Uygulama Sürümü:** 1.0

import 'package:flutter/material.dart';

class KvkkScreen extends StatelessWidget {
  const KvkkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KVKK Aydınlatma Metni')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 16, height: 1.5),
              children: [
                TextSpan(
                  text:
                      'Kişisel Verilerin Korunması Hakkında Aydınlatma Metni\n\n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                TextSpan(
                  text:
                      'AI Nutri Coach uygulaması olarak, 6698 sayılı Kişisel Verilerin Korunması Kanunu (“KVKK”) uyarınca, kişisel verilerinizin güvenliğine önem veriyor ve bu verilerinizi mevzuata uygun şekilde işliyoruz.\n\n',
                ),
                TextSpan(
                  text: '1. Veri Sorumlusu\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Bu metin, veri sorumlusu sıfatıyla hareket eden AI Nutri Coach Geliştirici Ekibi tarafından hazırlanmıştır.\n\n',
                ),
                TextSpan(
                  text: '2. İşlenen Kişisel Veriler\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Ad, soyad, yaş, cinsiyet, e-posta, sağlık bilgileri (alerji, hastalık), menstrüel döngü bilgileri, duygu durum verileri, kullanım geçmişi gibi veriler işlenebilir.\n\n',
                ),
                TextSpan(
                  text: '3. Veri İşleme Amaçları\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Size özel diyet önerileri sunmak, kullanıcı deneyimini iyileştirmek, duygu ve döngü analizleri yapmak ve istatistiksel değerlendirmelerde bulunmak.\n\n',
                ),
                TextSpan(
                  text: '4. Hukuki Sebepler\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Kişisel verileriniz, açık rızanıza dayalı olarak KVKK’nın 5. maddesi kapsamında işlenmektedir.\n\n',
                ),
                TextSpan(
                  text: '5. Verilerin Aktarımı\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Verileriniz sadece hizmet sağlamak amacıyla (örneğin Gemini AI API) sınırlı şekilde 3. taraf hizmetlerle paylaşılabilir. Ticari amaçla aktarım yapılmaz.\n\n',
                ),
                TextSpan(
                  text: '6. Saklama Süresi\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Verileriniz kullanım amacı sona erdiğinde veya açık rızanız geri çekildiğinde silinir, yok edilir ya da anonimleştirilir.\n\n',
                ),
                TextSpan(
                  text: '7. Haklarınız\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'KVKK’nın 11. maddesi gereği verilerinize erişme, düzeltme, silme, itiraz etme ve açık rızanızı geri çekme haklarınız bulunmaktadır. Talepleriniz için: demo@ainutri.app\n\n',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

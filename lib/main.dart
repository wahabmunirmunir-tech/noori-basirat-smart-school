import 'package:flutter/material.dart';

void main() {
  runApp(const NooriBaseeratApp());
}

class NooriBaseeratApp extends StatelessWidget {
  const NooriBaseeratApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نُوری بَصِیرَت',
      theme: ThemeData(fontFamily: 'Jameel'),
      home: const LanguageScreen(),
    );
  }
}

// 1۔ زبانوں والا صفحہ
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});
  final List<Map<String, String>> langs = const [
    {'code': 'ur', 'name': 'اردو'},
    {'code': 'ps', 'name': 'پشتو'},
    {'code': 'ar', 'name': 'العربية'},
    {'code': 'en', 'name': 'English'},
    {'code': 'hi', 'name': 'हिंदी'},
    {'code': 'zh', 'name': '中文'},
    {'code': 'de', 'name': 'Deutsch'},
    {'code': 'it', 'name': 'Italiano'},
    {'code': 'fr', 'name': 'Français'},
    {'code': 'tr', 'name': 'Türkçe'},
    {'code': 'fa', 'name': 'فارسی'},
    {'code': 'es', 'name': 'Español'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF021a12),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                borderRadius: BorderRadius.circular(30),
                color: Colors.black54,
              ),
              child: const Text('نُورِی بَصِیرَت 👁️', style: TextStyle(color: Color(0xFFFFD700), fontSize: 26, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            const Text('اپنی زبان منتخب کریں / Select Language', style: TextStyle(color: Color(0xFFF5E6A8))),
            const SizedBox(height: 15),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(15),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.8, crossAxisSpacing: 10, mainAxisSpacing: 10),
                itemCount: langs.length,
                itemBuilder: (context, i) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0a3d2e),
                      side: const BorderSide(color: Color(0xFFD4AF37)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen(selectedLang: langs[i]['name']!)));
                    },
                    child: Text('${i + 1}۔ ${langs[i]['name']}', style: const TextStyle(color: Color(0xFFF5E6A8), fontWeight: FontWeight.bold)),
                  );
                },
              ),
            ),
            const Text('قرآن میں عربی اصل رہے گی، ترجمہ آپ کی زبان میں آئے گا', style: TextStyle(color: Colors.grey, fontSize: 10)),
            const SizedBox(height: 80),
          ],
        ),
      ),
      // نیچے حلال بینر - کمائی والا
      bottomSheet: _halalBanner(),
    );
  }
}

// 2۔ مین سکرین
class MainScreen extends StatefulWidget {
  final String selectedLang;
  const MainScreen({super.key, required this.selectedLang});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int lessonsRead = 0;
  int tapCount = 0;
  DateTime lastTap = DateTime.now();

  void checkAd() {
    lessonsRead++;
    if (lessonsRead >= 2) {
      _showInterstitialAd();
      lessonsRead = 0;
    }
  }

  void _showInterstitialAd() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('🌙 حلال اسلامی اشتہار', style: TextStyle(color: Color(0xFF0A2F1F))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD4AF37), width: 2), borderRadius: BorderRadius.circular(10), color: const Color(0xFFfdf6e3)),
              child: const Column(children: [
                Text('الحمدللہ حلال سفر سروس', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('عمرہ، حج، ویزہ، ٹکٹ - مکمل رہنمائی', style: TextStyle(fontSize: 13)),
                SizedBox(height: 5),
                Text('AdMob ID: ca-app-pub-XXXXXXXXXXXXXXXX - صرف اسلامی', style: TextStyle(fontSize: 10, color: Colors.green)),
              ]),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('❌ بند کریں'))],
      ),
    );
  }

  void _ownerMode() {
    final now = DateTime.now();
    if (now.difference(lastTap).inSeconds > 2) tapCount = 0;
    lastTap = now;
    tapCount++;
    if (tapCount >= 5) {
      tapCount = 0;
      showDialog(
        context: context,
        builder: (_) {
          String name = '', father = '';
          return AlertDialog(
            title: const Text('مالک کی تصدیق'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(onChanged: (v) => name = v, decoration: const InputDecoration(labelText: 'نام؟')),
              TextField(onChanged: (v) => father = v, decoration: const InputDecoration(labelText: 'والد کا نام؟')),
            ]),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (name.contains('وہاب') && father.contains('بخت')) {
                    Navigator.pop(context);
                    showDialog(context: context, builder: (_) => const AlertDialog(title: Text('مالک موڈ کھل گیا'), content: Text('کمائی نمبر (خفیہ): 03434378764\nعوام واٹس ایپ: 03209548869\n\nAdMob Banner ID: ca-app-pub-3940256099942544/6300978111\nInterstitial ID: ca-app-pub-3940256099942544/1033173712\n(یہ ٹیسٹ ID ہیں، اپنی اصلی ID سے بدلیں)')));
                  }
                },
                child: const Text('تصدیق'),
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titles = ['۱۔ نماز کیا ہے؟', '۲۔ نماز کا طریقہ', '۳۔ وضو کا طریقہ', '۴۔ سیرتِ مبارک ﷺ', '۵۔ تاریخِ اسلام', '۶۔ مسنون دعائیں', '۷۔ اذکار', '۸۔ امتحان', '۹۔ مشکل الفاظ', '۱۰۔ مکمل قرآن مجید'];
    return Scaffold(
      backgroundColor: const Color(0xFF021a12),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: GestureDetector(
          onTap: _ownerMode,
          child: Container(
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFD4AF37), width: 3)), image: DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1585664811087-47f65abbad64?q=80&w=900'), fit: BoxFit.cover)),
            child: Center(child: Container(margin: const EdgeInsets.only(top: 25), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), decoration: BoxDecoration(color: Colors.black87, border: Border.all(color: const Color(0xFFD4AF37), width: 2.5), borderRadius: BorderRadius.circular(35)), child: const Text('نُورِی بَصِیرَت', style: TextStyle(color: Color(0xFFFFD700), fontSize: 24, fontWeight: FontWeight.bold)))),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.1),
              itemCount: titles.length,
              itemBuilder: (context, i) {
                bool isQuran = i == 9;
                return GestureDetector(
                  onTap: checkAd,
                  child: Container(
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0a3d2e), Color(0xFF06291f)]), border: Border.all(color: i == 9? const Color(0xFFFFD700) : const Color(0xFFD4AF37), width: isQuran? 2.5 : 1.5), borderRadius: BorderRadius.circular(18)),
                    padding: const EdgeInsets.all(10),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(titles[i], textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFF5E6A8), fontSize: 17, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(alignment: WrapAlignment.center, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5), decoration: BoxDecoration(color: const Color(0xFFD4AF37), borderRadius: BorderRadius.circular(14)), child: Text(isQuran? 'پڑھیے، سنیے، دیکھیے' : 'پڑھیے', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF021a12))))]),
                      if (isQuran) Text('ترجمہ: ${widget.selectedLang}', style: const TextStyle(color: Color(0xFFF5E6A8), fontSize: 11)),
                    ]),
                  ),
                );
              },
            ),
          ),
          Container(
            color: const Color(0xFF021a12),
            padding: const EdgeInsets.all(15),
            child: Column(children: [
              Text('مالک: وہاب منیر - ${widget.selectedLang}', style: const TextStyle(color: Color(0xFFD4AF37))),
              const SizedBox(height: 10),
              ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), onPressed: () {}, icon: const Text('📱'), label: const Text('واٹس ایپ پر رابطہ کریں - 03209548869', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              const SizedBox(height: 8),
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0x1AD4AF37), border: Border.all(color: const Color(0xFFD4AF37)), borderRadius: BorderRadius.circular(10)), child: const Text('📢 بیرون ملک، ویزہ، عمرہ، حج رہنمائی کے لیے رابطہ کریں۔', style: TextStyle(color: Color(0xFFF5E6A8), fontSize: 12))),
            ]),
          ),
          _halalBanner(),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

Widget _halalBanner() {
  return Container(
    height: 65,
    color: Colors.black,
    padding: const EdgeInsets.all(5),
    child: Container(
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD4AF37), width: 1.5), borderRadius: BorderRadius.circular(10), color: const Color(0xFF0A2F1F)),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(children: [
        Container(width: 30, height: 30, decoration: const BoxDecoration(color: Color(0xFFD4AF37), shape: BoxShape.circle), child: const Center(child: Text('حلال', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)))),
        const SizedBox(width: 8),
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text('📢 عمرہ، حج، ویزہ، ٹریول - حلال سروس', style: TextStyle(color: Color(0xFFFFD700), fontSize: 12, fontWeight: FontWeight.bold)), Text('واٹس ایپ: 03209548869 - صرف اسلامی اشتہار', style: TextStyle(color: Colors.white, fontSize: 10))])),
      ]),
    ),
  );
}

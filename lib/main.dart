import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
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
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD4AF37), width: 2), borderRadius: BorderRadius.circular(30), color: Colors.black54),
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
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0a3d2e), side: const BorderSide(color: Color(0xFFD4AF37)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen(selectedLang: langs[i]['name']!))); },
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
      bottomSheet: const HalalBannerAd(),
    );
  }
}

class MainScreen extends StatefulWidget {
  final String selectedLang;
  const MainScreen({super.key, required this.selectedLang});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final String bannerId = 'ca-app-pub-6967191660339063/1424495325';
  final String boxId = 'ca-app-pub-6967191660339063/3603827158';
  final String paraId = 'ca-app-pub-6967191660339063/7239928785';
  final String appOpenId = 'ca-app-pub-6967191660339063/7048357094';

  InterstitialAd? _boxAd;
  InterstitialAd? _paraAd;
  int paraPageCount = 0;
  int tapCount = 0;
  DateTime lastTap = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadBoxAd();
    _loadParaAd();
  }

  void _loadBoxAd() {
    InterstitialAd.load(adUnitId: boxId, request: const AdRequest(), adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) => _boxAd = ad, onAdFailedToLoad: (e) => _boxAd = null));
  }

  void _loadParaAd() {
    InterstitialAd.load(adUnitId: paraId, request: const AdRequest(), adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) => _paraAd = ad, onAdFailedToLoad: (e) => _paraAd = null));
  }

  void _showBoxAd() {
    if (_boxAd!= null) { _boxAd!.show(); _boxAd!.fullScreenContentCallback = FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) { ad.dispose(); _loadBoxAd(); }); }
  }

  void _showParaAdWithDelay() {
    paraPageCount++;
    if (paraPageCount % 2 == 0) {
      Future.delayed(const Duration(seconds: 3), () {
        if (_paraAd!= null) { _paraAd!.show(); _paraAd!.fullScreenContentCallback = FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) { ad.dispose(); _loadParaAd(); }); }
      });
    }
  }

  void _ownerMode() {
    final now = DateTime.now();
    if (now.difference(lastTap).inSeconds > 2) tapCount = 0;
    lastTap = now; tapCount++;
    if (tapCount >= 5) {
      tapCount = 0;
      showDialog(context: context, builder: (_) {
          String name = '', father = '';
          return AlertDialog(title: const Text('مالک کی تصدیق'), content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(onChanged: (v) => name = v, decoration: const InputDecoration(labelText: 'نام؟')), TextField(onChanged: (v) => father = v, decoration: const InputDecoration(labelText: 'والد کا نام؟'))]),
            actions: [ElevatedButton(onPressed: () { if (name.contains('وہاب') && father.contains('بخت')) { Navigator.pop(context); showDialog(context: context, builder: (_) => AlertDialog(title: const Text('مالک موڈ کھل گیا'), content: Text('خفیہ: 03434378764\nعوام: 03209548869\n\nBanner: $bannerId\nBox: $boxId\nPara: $paraId\nAppOpen: $appOpenId'))); } }, child: const Text('تصدیق'))]);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titles = ['۱۔ نماز کیا ہے؟', '۲۔ نماز کا طریقہ', '۳۔ وضو کا طریقہ', '۴۔ سیرتِ مبارک ﷺ', '۵۔ تاریخِ اسلام', '۶۔ مسنون دعائیں', '۷۔ اذکار', '۸۔ امتحان', '۹۔ مشکل الفاظ', '۱۰۔ مکمل قرآن مجید'];
    return Scaffold(
      backgroundColor: const Color(0xFF021a12),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: GestureDetector(onTap: _ownerMode, child: Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFD4AF37), width: 3)), image: DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1585664811087-47f65abbad64?q=80&w=900'), fit: BoxFit.cover)), child: Center(child: Container(margin: const EdgeInsets.only(top: 25), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), decoration: BoxDecoration(color: Colors.black87, border: Border.all(color: const Color(0xFFD4AF37), width: 2.5), borderRadius: BorderRadius.circular(35)), child: const Text('نُورِی بَصِیرَت', style: TextStyle(color: Color(0xFFFFD700), fontSize: 24, fontWeight: FontWeight.bold)))))),
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
                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    _showBoxAd();
                    if (isQuran) { Navigator.push(context, MaterialPageRoute(builder: (_) => QuranParaScreen(selectedLang: widget.selectedLang, onPageChanged: _showParaAdWithDelay))); }
                    else { Navigator.push(context, MaterialPageRoute(builder: (_) => LessonDetailScreen(title: titles[i]))); }
                  },
                  child: Container(
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0a3d2e), Color(0xFF06291f)]), border: Border.all(color: isQuran? const Color(0xFFFFD700) : const Color(0xFFD4AF37), width: isQuran? 2.5 : 1.5), borderRadius: BorderRadius.circular(18)),
                    padding: const EdgeInsets.all(10),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(titles[i], textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFF5E6A8), fontSize: 17, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5), decoration: BoxDecoration(color: const Color(0xFFD4AF37), borderRadius: BorderRadius.circular(14)), child: Text(isQuran? 'پڑھیے، سنیے، دیکھیے' : 'پڑھیے', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF021a12)))),
                      if (isQuran) Text('ترجمہ: ${widget.selectedLang}', style: const TextStyle(color: Color(0xFFF5E6A8), fontSize: 11)),
                    ]),
                  ),
                );
              },
            ),
          ),
          Container(color: const Color(0xFF021a12), padding: const EdgeInsets.all(15), child: Column(children: [Text('مالک: وہاب منیر - ${widget.selectedLang}', style: const TextStyle(color: Color(0xFFD4AF37))), const SizedBox(height: 10), ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), onPressed: () {}, icon: const Text('📱'), label: const Text('واٹس ایپ پر رابطہ کریں - 03209548869', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))])),
          const HalalBannerAd(),
        ],
      ),
    );
  }
}

class HalalBannerAd extends StatefulWidget {
  const HalalBannerAd({super.key});
  @override
  State<HalalBannerAd> createState() => _HalalBannerAdState();
}

class _HalalBannerAdState extends State<HalalBannerAd> {
  BannerAd? _bannerAd;
  final String bannerId = 'ca-app-pub-6967191660339063/1424495325';
  @override
  void initState() { super.initState(); _bannerAd = BannerAd(adUnitId: bannerId, size: AdSize.banner, request: const AdRequest(), listener: BannerAdListener(onAdLoaded: (ad) => setState(() {}), onAdFailedToLoad: (ad, err) => ad.dispose()))..load(); }
  @override
  void dispose() { _bannerAd?.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    if (_bannerAd == null) { return Container(height: 65, color: Colors.black, child: const Center(child: Text('حلال اشتہار لوڈ ہو رہا ہے...', style: TextStyle(color: Colors.white, fontSize: 10)))); }
    return Container(height: 65, color: Colors.black, alignment: Alignment.center, child: AdWidget(ad: _bannerAd!));
  }
}

class LessonDetailScreen extends StatelessWidget {
  final String title;
  const LessonDetailScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) { return Scaffold(appBar: AppBar(title: Text(title), backgroundColor: const Color(0xFF0a3d2e)), body: Center(child: Text('$title کا مواد', style: const TextStyle(fontSize: 22)))); }
}

class QuranParaScreen extends StatefulWidget {
  final String selectedLang;
  final VoidCallback onPageChanged;
  const QuranParaScreen({super.key, required this.selectedLang, required this.onPageChanged});
  @override
  State<QuranParaScreen> createState() => _QuranParaScreenState();
}

class _QuranParaScreenState extends State<QuranParaScreen> {
  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('مکمل قرآن - ${widget.selectedLang}'), backgroundColor: const Color(0xFF0a3d2e)),
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (index) { widget.onPageChanged(); },
        itemCount: 30,
        itemBuilder: (context, index) { return Center(child: Text('پارہ ${index + 1}', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold))); },
      ),
    );
  }
}

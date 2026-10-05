import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  void initState() { super.initState(); _loadBoxAd(); _loadParaAd(); }

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
                  onTap: () async {
                    if (isQuran) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => QuranMainScreen(selectedLang: widget.selectedLang, onPageChanged: _showParaAdWithDelay)));
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => LessonDetailScreen(title: titles[i], selectedLang: widget.selectedLang)));
                    }
                    await Future.delayed(const Duration(seconds: 2));
                    _showBoxAd();
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

// مکمل مواد والی سکرین
class LessonDetailScreen extends StatelessWidget {
  final String title;
  final String selectedLang;
  const LessonDetailScreen({super.key, required this.title, required this.selectedLang});

  String getContent(){
    if(title.contains('نماز کیا ہے')){
      return 'نماز اسلام کا دوسرا رکن ہے۔\n\nقرآن میں 700 سے زیادہ جگہ نماز کا ذکر ہے۔\n\nنماز مومن کی معراج ہے، بے حیائی سے روکتی ہے۔\n\nفرض نمازیں 5 ہیں: فجر، ظہر، عصر، مغرب، عشاء۔';
    } else if(title.contains('نماز کا طریقہ')){
      return 'نماز کا مکمل طریقہ:\n\n1- نیت: دل میں نیت کریں\n2- تکبیر تحریمہ: اللہ اکبر\n3- ثناء، سورہ فاتحہ، کوئی سورت\n4- رکوع: سبحان ربی العظیم 3 بار\n5- قومہ، سجدہ: سبحان ربی الاعلی 3 بار\n6- تشہد، درود، دعا اور سلام\n\nہر فرض نماز کی رکعتیں اس میں تفصیل سے پڑھیں۔';
    } else if(title.contains('وضو')){
      return 'وضو کا مکمل طریقہ:\n\n1- نیت\n2- بسم اللہ\n3- ہاتھ 3 بار\n4- کلی 3 بار\n5- ناک میں پانی 3 بار\n6- چہرہ 3 بار\n7- ہاتھ کہنیوں تک 3 بار\n8- مسح سر کا\n9- پاؤں ٹخنوں تک 3 بار\n\nوضو کے فرائض 4 ہیں۔';
    } else if(title.contains('سیرت')){
      return 'سیرت النبی ﷺ:\n\nولادت: 571 عیسوی مکہ میں۔\nوالد: عبداللہ، والدہ: آمنہ۔\n40 سال کی عمر میں نبوت۔\n13 سال مکہ میں تبلیغ۔\n10 سال مدینہ میں۔\n632 عیسوی میں وصال۔\n\nآپ ﷺ کی زندگی ہمارے لیے بہترین نمونہ ہے۔';
    } else if(title.contains('تاریخ')){
      return 'تاریخ اسلام:\n\nہجرت 622 عیسوی۔\nغزوہ بدر 2 ہجری۔\nفتح مکہ 8 ہجری۔\nخلفائے راشدین: حضرت ابوبکر، عمر، عثمان، علی رضی اللہ عنہم۔\nبنو امیہ، بنو عباس کا دور۔';
    } else if(title.contains('دعائیں')){
      return 'مسنون دعائیں:\n\nسونے کی دعا: اللھم باسمک اموت و احیا\nجاگنے کی: الحمدللہ الذی احیانا\nکھانے سے پہلے: بسم اللہ\nکھانے کے بعد: الحمدللہ الذی اطعمنا\nسفر کی دعا: سبحان الذی سخر لنا';
    } else if(title.contains('اذکار')){
      return 'صبح شام کے اذکار:\n\nسبحان اللہ 33 بار\nالحمدللہ 33 بار\nاللہ اکبر 34 بار\nآیت الکرسی\nسورہ اخلاص، فلق، ناس 3-3 بار';
    } else if(title.contains('امتحان')){
      return 'امتحان:\n\nیہاں سے آپ نے جو پڑھا ہے اس کا ٹیسٹ ہوگا۔\n\nمثلاً: نماز کی کتنی رکعتیں ہیں؟\nوضو کے فرائض کتنے ہیں؟\n\n(اس میں ہم بعد میں MCQ سسٹم لگائیں گے)';
    } else if(title.contains('مشکل الفاظ')){
      return 'مشکل الفاظ کے معانی:\n\nصلوۃ: نماز\nصوم: روزہ\nوضوء: پاکی\nطہارت: پاکیزگی\nسجدہ: اللہ کے سامنے جھکنا';
    }
    return 'مواد جلد آرہا ہے...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: const Color(0xFF0a3d2e)),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Text(getContent(), style: const TextStyle(fontSize: 20, height: 1.8))),
      bottomSheet: const HalalBannerAd(),
    );
  }
}

// قرآن والا نیا سسٹم
class QuranMainScreen extends StatelessWidget {
  final String selectedLang;
  final VoidCallback onPageChanged;
  const QuranMainScreen({super.key, required this.selectedLang, required this.onPageChanged});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مکمل قرآن مجید'), backgroundColor: const Color(0xFF0a3d2e)),
      body: Column(children: [
        const SizedBox(height: 20),
        ListTile(title: const Text('پارہ کے حساب سے پڑھیں', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), subtitle: Text('30 پارے - ترجمہ: $selectedLang'), trailing: const Icon(Icons.arrow_forward), onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (_) => QuranParaScreen(selectedLang: selectedLang, onPageChanged: onPageChanged))); }),
        const Divider(),
        ListTile(title: const Text('سورت کے حساب سے پڑھیں', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), subtitle: const Text('114 سورتیں'), trailing: const Icon(Icons.arrow_forward), onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (_) => QuranSurahScreen(selectedLang: selectedLang, onPageChanged: onPageChanged))); }),
      ]),
    );
  }
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
  int currentPara = 0;
  @override
  void initState(){ super.initState(); _loadBookmark(); }
  Future<void> _loadBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    setState((){ currentPara = prefs.getInt('quran_bookmark')?? 0; });
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.jumpToPage(currentPara));
  }
  Future<void> _saveBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('quran_bookmark', _controller.page?.toInt()?? 0);
    if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('نشانی محفوظ ہو گئی ✅')));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('پارے - ${widget.selectedLang}'), backgroundColor: const Color(0xFF0a3d2e), actions: [IconButton(onPressed: _saveBookmark, icon: const Icon(Icons.bookmark_add), tooltip: 'نشانی لگائیں')]),
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (index) { widget.onPageChanged(); },
        itemCount: 30,
        itemBuilder: (context, index) {
          return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('پارہ ${index + 1}', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('بِسْمِ اللہِ الرَّحْمٰنِ الرَّحِیْمِ\n\n[یہاں پارہ ${index+1} کا عربی متن آئے گا]\n\nترجمہ (${widget.selectedLang}): یہاں ترجمہ آئے گا', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            ElevatedButton.icon(onPressed: _saveBookmark, icon: const Icon(Icons.bookmark), label: const Text('نشانی لگائیں'))
          ]));
        },
      ),
      bottomSheet: const HalalBannerAd(),
    );
  }
}

class QuranSurahScreen extends StatelessWidget {
  final String selectedLang;
  final VoidCallback onPageChanged;
  QuranSurahScreen({super.key, required this.selectedLang, required this.onPageChanged});
  final List<String> surahs = List.generate(114, (i) => 'سورۃ ${i+1}');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('114 سورتیں'), backgroundColor: const Color(0xFF0a3d2e)),
      body: ListView.builder(itemCount: 114, itemBuilder: (context, i) => ListTile(title: Text(surahs[i]), onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (_) => QuranParaScreen(selectedLang: selectedLang, onPageChanged: onPageChanged))); })),
      bottomSheet: const HalalBannerAd(),
    );
  }
}

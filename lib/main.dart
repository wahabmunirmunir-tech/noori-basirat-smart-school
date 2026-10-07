import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_flip/page_flip.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(HolyQuranApp());
}

class HolyQuranApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Holy Quran',
      theme: ThemeData(primarySwatch: Colors.green),
      home: LanguagePage(),
    );
  }
}

// 1. زبان کا صفحہ - 20 زبانیں
class LanguagePage extends StatelessWidget {
  final List<String> languages = [
    "گوجری", "پشتو", "اردو", "عربی", "English",
    "ترکی", "فارسی", "بنگالی", "ہندی", "ملیالم",
    "Français", "Deutsch", "Español", "Indonesia", "Melayu",
    "中文", "Русский", "Kiswahili", "Hausa", "O'zbek"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Holy Quran - Select Your Language"), backgroundColor: Color(0xFF0A4D2E), centerTitle: true),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: Icon(Icons.language, color: Color(0xFF0A4D2E)),
            title: Text(languages[i], style: TextStyle(fontSize: 18)),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
            },
          );
        },
      ),
    );
  }
}

// 2. مرکزی صفحہ - 6 باکس
class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> boxes = [
    {"name": "وضو - طریقہ، فضیلت اور دعائیں", "icon": Icons.water_drop},
    {"name": "نماز - طریقہ، فضیلت، الفاظ", "icon": Icons.mosque},
    {"name": "قرآن مجید", "icon": Icons.menu_book},
    {"name": "اذکار", "icon": Icons.self_improvement},
    {"name": "دعائیں", "icon": Icons.front_hand},
    {"name": "اسلامی تاریخ", "icon": Icons.history_edu},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Holy Quran"), backgroundColor: Color(0xFF0A4D2E), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
              itemCount: boxes.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    if (i == 2) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => QuranOptionPage()));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xFFD4AF37), width: 2),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(boxes[i]["icon"], size: 40, color: Color(0xFF0A4D2E)),
                        SizedBox(height: 10),
                        Text(boxes[i]["name"], textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // بینر اشتہار
          MyBannerAd(),
        ],
      ),
    );
  }
}

class QuranOptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("قرآن مجید"), backgroundColor: Color(0xFF0A4D2E)),
      body: Column(
        children: [
          ListTile(title: Text("① پاروں کے حساب سے پڑھیں - 30 پارے"), leading: Icon(Icons.list), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => JuzListPage()))),
          Divider(),
          ListTile(title: Text("② سورتوں کے حساب سے پڑھیں - 114 سورتیں"), leading: Icon(Icons.book), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SurahListPage()))),
          Spacer(),
          MyBannerAd(),
        ],
      ),
    );
  }
}

// پاروں کی لسٹ
class JuzListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("30 پارے"), backgroundColor: Color(0xFF0A4D2E)),
      body: ListView.builder(
        itemCount: 30,
        itemBuilder: (context, i) {
          int pageNumber = (i * 20) + 1; // ہر پارہ تقریباً 20 صفحے
          return ListTile(
            title: Text("پارہ ${i + 1}"),
            subtitle: Text("صفحہ نمبر $pageNumber سے شروع"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuranBookPage(startPage: pageNumber))),
          );
        },
      ),
    );
  }
}

// سورتوں کی لسٹ
class SurahListPage extends StatelessWidget {
  final List<String> surahs = List.generate(114, (i) => "سورت ${i + 1}");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("114 سورتیں"), backgroundColor: Color(0xFF0A4D2E)),
      body: ListView.builder(
        itemCount: 114,
        itemBuilder: (context, i) => ListTile(
          title: Text(surahs[i]),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuranBookPage(startPage: i * 5 + 1))),
        ),
      ),
    );
  }
}

// اصلی کتاب جیسا صفحہ پلٹنے والا
class QuranBookPage extends StatefulWidget {
  final int startPage;
  QuranBookPage({required this.startPage});
  @override
  _QuranBookPageState createState() => _QuranBookPageState();
}

class _QuranBookPageState extends State<QuranBookPage> {
  final _controller = GlobalKey<PageFlipWidgetState>();
  InterstitialAd? _interstitialAd;
  int pageTurnCount = 0;

  @override
  void initState() {
    super.initState();
    _loadInterstitial();
  }

  void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // ٹیسٹ آئی ڈی
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (e) => print("Ad failed"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EEDC),
      appBar: AppBar(
        title: Text("Holy Quran - Page ${widget.startPage}"), // اوپر ایپ کا نام + صفحہ نمبر
        backgroundColor: Color(0xFF0A4D2E),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageFlipWidget(
              key: _controller,
              backgroundColor: Color(0xFFF5EEDC),
              lastPage: Container(color: Colors.white, child: Center(child: Text("الختم"))),
              children: List.generate(604, (index) {
                // تصویروں جیسی لکھائی - انٹرنیٹ سے قرآن کے اصلی صفحے
                int pageNum = index + 1;
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xFFD4AF37), width: 3),
                  ),
                  child: Column(
                    children: [
                      Container(padding: EdgeInsets.all(8), color: Color(0xFF0A4D2E), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Holy Quran", style: TextStyle(color: Colors.white)), Text("Page $pageNum", style: TextStyle(color: Colors.white))])),
                      Expanded(
                        child: Image.network(
                          "https://www.mp3quran.net/api/quran_pages_arabic/quran_page_${pageNum.toString().padLeft(3, '0')}.png",
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => Center(child: Text("صفحہ $pageNum\nعربی متن یہاں ہوگا", textAlign: TextAlign.center, style: TextStyle(fontSize: 24))),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              onPageFlipped: (page) {
                pageTurnCount++;
                if (pageTurnCount % 6 == 0) {
                  _interstitialAd?.show();
                  _loadInterstitial();
                }
              },
            ),
          ),
          MyBannerAd(),
        ],
      ),
    );
  }
}

// بینر اشتہار ویجٹ
class MyBannerAd extends StatefulWidget {
  @override
  _MyBannerAdState createState() => _MyBannerAdState();
}

class _MyBannerAdState extends State<MyBannerAd> {
  BannerAd? _bannerAd;
  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // ٹیسٹ بینر
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd == null) return SizedBox(height: 50);
    return Container(height: 50, child: AdWidget(ad: _bannerAd!));
  }
}

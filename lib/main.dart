import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
      theme: ThemeData(fontFamily: 'Jameel'),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> boxes = [
    {"title": "وضو کا طریقہ", "icon": Icons.water_drop, "color": Color(0xFF0A4D2E), "page": WuzuPage()},
    {"title": "نماز کا طریقہ", "icon": Icons.mosque, "color": Color(0xFF1565C0), "page": NamazPage()},
    {"title": "قرآن مجید", "icon": Icons.menu_book, "color": Color(0xFF2E7D32), "page": QuranPage()},
    {"title": "اذکار", "icon": Icons.self_improvement, "color": Color(0xFF6A1B9A), "page": AzkarPage()},
    {"title": "مسنون دعائیں", "icon": Icons.front_hand, "color": Color(0xFFEF6C00), "page": DuainPage()},
    {"title": "اسلامی تاریخ", "icon": Icons.history_edu, "color": Color(0xFF4E342E), "page": TareekhPage()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("نوری بصیرت سمارٹ سکول", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF0A4D2E),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: boxes.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => boxes[index]["page"]));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: boxes[index]["color"],
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(boxes[index]["icon"], size: 50, color: Colors.white),
                          SizedBox(height: 12),
                          Text(boxes[index]["title"], style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          MyBannerAd(),
        ],
      ),
    );
  }
}

// --- باکس کے اندر والے صفحات ---

class WuzuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("وضو کا طریقہ"), backgroundColor: Color(0xFF0A4D2E)), body: Center(child: Text("یہاں وضو کے 4 فرائض اور مکمل طریقہ آئے گا")));
  }
}
class NamazPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("نماز کا طریقہ"), backgroundColor: Color(0xFF1565C0)), body: Center(child: Text("یہاں نماز کا مکمل طریقہ آئے گا")));
  }
}
class QuranPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("قرآن مجید - 20 زبانوں میں"), backgroundColor: Color(0xFF2E7D32)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("وہاب بھائی یہاں قرآن کتاب جیسا پلٹے گا", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(onPressed: (){}, child: Text("پارہ 1 شروع کریں")),
          ],
        ),
      ),
    );
  }
}
class AzkarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("اذکار"), backgroundColor: Color(0xFF6A1B9A)), body: Center(child: Text("صبح شام کے اذکار")));
  }
}
class DuainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("مسنون دعائیں"), backgroundColor: Color(0xFFEF6C00)), body: Center(child: Text("کھانے پینے سونے جاگنے کی دعائیں")));
  }
}
class TareekhPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("اسلامی تاریخ"), backgroundColor: Color(0xFF4E342E)), body: Center(child: Text("انبیاء اور صحابہ کی تاریخ")));
  }
}

// --- بینر اشتہار والا کوڈ وہی آپ والا ---
class MyBannerAd extends StatefulWidget {
  @override
  _MyBannerAdState createState() => _MyBannerAdState();
}
class _MyBannerAdState extends State<MyBannerAd> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) { setState(() { _isLoaded = true; }); },
        onAdFailedToLoad: (ad, err) { ad.dispose(); },
      ),
    )..load();
  }
  @override
  void dispose() { _bannerAd?.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) return SizedBox(height: 50);
    return Container(height: 50, alignment: Alignment.center, child: AdWidget(ad: _bannerAd!));
  }
}

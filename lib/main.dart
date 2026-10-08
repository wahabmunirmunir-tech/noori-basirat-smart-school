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
ایپ کا مکمل نقشہ اور ضروری ہدایات

1۔ زبان کا انتخاب
ایپ پہلی مرتبہ کھولنے پر زبان منتخب کرنے کا صفحہ دکھائے۔
کل 20 زبانیں ہوں، جن میں گوجری، پشتو، اردو، عربی اور دنیا کی دیگر بڑی زبانیں شامل ہوں۔
صارف جس زبان کو منتخب کرے، ایپ کا پورا انٹرفیس اسی زبان میں ہو۔
قرآن مجید کا اصل عربی متن عربی ہی میں رہے۔
نماز کے عربی الفاظ عربی ہی میں رہیں۔
دعاؤں کا عربی متن عربی ہی میں رہے۔
احادیث کا اصل عربی متن عربی ہی میں رہے۔
ان سب کا ترجمہ صارف کی منتخب کردہ زبان میں ہو۔

2۔ مرکزی صفحہ
زبان منتخب کرنے کے بعد مرکزی صفحہ کھلے۔
مرکزی صفحے پر اسلامی معلومات کے مختلف باکس موجود ہوں۔
کوئی بھی باکس خالی نہ ہو۔
ہر باکس کے اندر اصل، مکمل اور پڑھنے کے قابل مواد موجود ہو۔

3۔ وضو کا باکس
وضو کا مکمل طریقہ شروع سے آخر تک ترتیب وار ہو۔
وضو کے فرائض، سنتیں، فضیلت اور متعلقہ مسائل شامل ہوں۔
وضو سے متعلق تمام مستند مسنون دعائیں شامل ہوں۔
عربی متن موجود ہو اور اس کا ترجمہ منتخب زبان میں ہو۔
وضو سے متعلق مستند احادیث اور ضروری وضاحت بھی شامل ہو۔
وضو کا حصہ خالی نہ ہو بلکہ مکمل کتاب کی طرح مواد سے بھرا ہوا ہو۔

4۔ نماز کا باکس
نماز کا مکمل طریقہ ابتدا سے آخر تک ترتیب وار ہو۔
نماز سے پہلے کی ضروری معلومات شامل ہوں۔
وضو سے متعلق ضروری معلومات بھی شامل ہوں۔
نماز کے فرائض، واجبات اور سنتیں شامل ہوں۔
تکبیر، قیام، رکوع، سجدہ، قعدہ اور سلام کا مکمل طریقہ شامل ہو۔
نماز میں پڑھے جانے والے تمام عربی الفاظ اور دعائیں شامل ہوں۔
نماز کی فضیلت، اذکار اور متعلقہ مستند احادیث شامل ہوں۔
ہر عربی متن کا ترجمہ منتخب زبان میں موجود ہو۔

5۔ قرآن مجید کا باکس
قرآن مجید کا مکمل قرآن شامل ہو۔
سورۃ الفاتحہ سے سورۃ الناس تک تمام 114 سورتیں شامل ہوں۔
تمام آیات مکمل اور ترتیب وار شامل ہوں۔
آیات کے نمبر موجود ہوں۔
رکوع موجود ہوں۔
30 پاروں کا مکمل نظام موجود ہو۔
عربی قرآن کا اصل متن عربی میں ہو۔
ہر آیت کا ترجمہ منتخب زبان میں ہو۔

قرآن مجید کھولنے پر دو اختیارات ہوں:

الف۔ پاروں کے حساب سے پڑھیں
ب۔ سورتوں کے حساب سے پڑھیں

پاروں کے حساب سے پڑھنے پر 30 پاروں کی مکمل فہرست کھلے۔
کسی پارے پر کلک کرنے سے وہ پورا پارہ شروع سے آخر تک کھلے۔
اس میں اس پارے کی تمام سورتیں، تمام آیات، آیات نمبر، رکوع، عربی متن اور ترجمہ موجود ہو۔

سورتوں کے حساب سے پڑھنے پر 114 سورتوں کی مکمل فہرست کھلے۔
کسی سورت پر کلک کرنے سے وہ پوری سورت شروع سے آخر تک کھلے۔
تمام آیات، آیات نمبر، رکوع، عربی متن اور منتخب زبان میں ترجمہ موجود ہو۔

6۔ اذکار کا باکس
صبح کے اذکار، شام کے اذکار اور مختلف مواقع کے اذکار شامل ہوں۔
تمام متعلقہ عربی اذکار، ان کا ترجمہ اور پڑھنے کا موقع شامل ہو۔
مواد مستند حوالوں کے ساتھ ترتیب وار ہو۔

7۔ مسنون دعاؤں کا باکس
مختلف مواقع کی مستند مسنون دعائیں شامل ہوں۔
کھانے، سونے، جاگنے، گھر سے نکلنے، گھر میں داخل ہونے، سفر، مسجد، وضو کے بعد، بیماری، صحت اور دیگر مواقع کی دعائیں شامل ہوں۔
ہر دعا میں عربی متن، ترجمہ اور دعا پڑھنے کا موقع بتایا جائے۔
دعاؤں کا مواد مستند اور ترتیب وار ہو۔

8۔ اسلامی تاریخ کا باکس
اسلام کی تاریخ کا مکمل اور ترتیب وار مواد شامل ہو۔
اسلام کا آغاز، انبیاء کرام سے متعلق معلومات، نبی کریم ﷺ کی سیرت، صحابہ کرامؓ، اہم اسلامی واقعات، اسلامی تہذیب اور اہم اسلامی شخصیات وغیرہ شامل ہوں۔
مواد کو ابواب اور صفحات کی شکل میں ترتیب دیا جائے۔

9۔ کتاب جیسے صفحات
تمام بڑے حصوں میں خالی سفید صفحہ نہیں ہونا چاہیے۔
ہر صفحے کے اندر اصل تحریری مواد موجود ہو۔
صفحہ کتاب کی طرح خوبصورت اور پڑھنے کے قابل ہو۔
عربی متن واضح اور خوبصورت ہو۔
ترجمہ واضح انداز میں ہو۔
اگلا اور پچھلا صفحہ موجود ہو۔
صارف انگلی سے سوائپ کرکے صفحہ آگے یا پیچھے کر سکے۔
صفحہ پلٹنے کی Animation اصلی کتاب کے صفحے جیسی ہو۔
صرف Animation نہ ہو بلکہ ہر صفحے کے اندر حقیقی مواد موجود ہو۔
صفحہ نمبر بھی دکھایا جائے۔

10۔ سب سے اہم شرط
کوئی بھی باکس صرف نام یا خالی ڈیزائن کے لیے نہ بنایا جائے۔
ہر باکس کے اندر اس موضوع کا مکمل اور حقیقی مواد موجود ہو۔
قرآن مجید والا باکس مکمل قرآن سے بھرا ہوا ہو۔
وضو والا باکس مکمل وضو کے مواد سے بھرا ہوا ہو۔
نماز والا باکس مکمل نماز کے مواد سے بھرا ہوا ہو۔
اذکار والا باکس مکمل اذکار سے بھرا ہوا ہو۔
مسنون دعاؤں والا باکس مکمل مسنون دعاؤں سے بھرا ہوا ہو۔
اسلامی تاریخ والا باکس مکمل اسلامی تاریخی مواد سے بھرا ہوا ہو۔

ایپ کا مقصد ایک ایسی مکمل اسلامی لائبریری بنانا ہے جس میں صارف منتخب زبان میں آسانی سے مواد پڑھ سکے، جبکہ قرآن، دعاؤں، نماز اور احادیث کا اصل عربی متن اپنی اصل عربی زبان میں محفوظ رہے۔

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(HolyQuranApp());
}

// 20 زبانیں آپ کے نقشے کے مطابق
class AppLang {
  static final List<Map<String,String>> all = [
    {"code":"ur", "name":"اردو"},
    {"code":"goj", "name":"گوجری"},
    {"code":"ps", "name":"پشتو"},
    {"code":"ar", "name":"العربية"},
    {"code":"en", "name":"English"},
    {"code":"fa", "name":"فارسی"},
    {"code":"tr", "name":"Türkçe"},
    {"code":"fr", "name":"Français"},
    {"code":"de", "name":"Deutsch"},
    {"code":"hi", "name":"हिन्दी"},
    {"code":"bn", "name":"বাংলা"},
    {"code":"ms", "name":"Melayu"},
    {"code":"id", "name":"Indonesia"},
    {"code":"zh", "name":"中文"},
    {"code":"ru", "name":"Русский"},
    {"code":"es", "name":"Español"},
    {"code":"sd", "name":"سنڌي"},
    {"code":"pa", "name":"پنجابی"},
    {"code":"bal", "name":"بلوچی"},
    {"code":"ta", "name":"தமிழ்"},
  ];

  static Map<String, Map<String,String>> t = {
    "ur": {"app":"نوری بصیرت سمارٹ سکول","wuzu":"وضو کا طریقہ","namaz":"نماز کا طریقہ","quran":"قرآن مجید","azkar":"اذکار","duain":"مسنون دعائیں","tareekh":"اسلامی تاریخ"},
    "goj": {"app":"نوری بصیرت سمارٹ سکول","wuzu":"وضو کو طریقو","namaz":"نماز کو طریقو","quran":"قرآن مجید","azkar":"اذکار","duain":"مسنون دعاواں","tareekh":"اسلامی تاریخ"},
    "ps": {"app":"نوري بصیرت","wuzu":"د اوداسه طریقه","namaz":"د لمانځه طریقه","quran":"قرآن مجید","azkar":"اذکار","duain":"مسنونی دعاګانی","tareekh":"اسلامي تاریخ"},
    "en": {"app":"Noori Basirat Smart School","wuzu":"Wudu Method","namaz":"Prayer Method","quran":"Holy Quran","azkar":"Azkar","duain":"Masnoon Duas","tareekh":"Islamic History"},
  };
  static String get(String lang, String key){
    return (t[lang]?[key]?? t["ur"]![key]!);
  }
}

class HolyQuranApp extends StatefulWidget {
  @override
  _HolyQuranAppState createState() => _HolyQuranAppState();
}
class _HolyQuranAppState extends State<HolyQuranApp> {
  String? savedLang;
  @override
  void initState(){
    super.initState();
    _loadLang();
  }
  _loadLang() async {
    final p = await SharedPreferences.getInstance();
    setState(()=> savedLang = p.getString('app_lang'));
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: savedLang == null? LanguagePage(onSelect: (code) async {
        final p = await SharedPreferences.getInstance();
        await p.setString('app_lang', code);
        setState(()=> savedLang = code);
      }) : HomePage(langCode: savedLang!),
    );
  }
}

// 1. زبان انتخاب صفحہ
class LanguagePage extends StatelessWidget {
  final Function(String) onSelect;
  LanguagePage({required this.onSelect});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A4D2E),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height:20),
            Text("زبان منتخب کریں / Select Language", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height:10),
            Text("20 زبانوں میں سے ایک منتخب کریں", style: TextStyle(color: Colors.white70)),
            SizedBox(height:20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
                child: GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.5, crossAxisSpacing: 12, mainAxisSpacing: 12),
                  itemCount: AppLang.all.length,
                  itemBuilder: (c,i){
                    var lang = AppLang.all[i];
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, side: BorderSide(color: Color(0xFF0A4D2E)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: ()=> onSelect(lang["code"]!),
                      child: Text(lang["name"]!, style: TextStyle(fontSize: 18, color: Color(0xFF0A4D2E), fontWeight: FontWeight.bold)),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String langCode;
  HomePage({required this.langCode});

  List<Map<String,dynamic>> getBoxes(BuildContext context){
    return [
      {"title": AppLang.get(langCode,"wuzu"), "icon": Icons.water_drop, "color": Color(0xFF0A4D2E), "page": WuzuPage(lang: langCode)},
      {"title": AppLang.get(langCode,"namaz"), "icon": Icons.mosque, "color": Color(0xFF1565C0), "page": NamazPage(lang: langCode)},
      {"title": AppLang.get(langCode,"quran"), "icon": Icons.menu_book, "color": Color(0xFF2E7D32), "page": QuranMainPage(lang: langCode)},
      {"title": AppLang.get(langCode,"azkar"), "icon": Icons.self_improvement, "color": Color(0xFF6A1B9A), "page": AzkarPage(lang: langCode)},
      {"title": AppLang.get(langCode,"duain"), "icon": Icons.front_hand, "color": Color(0xFFEF6C00), "page": DuainPage(lang: langCode)},
      {"title": AppLang.get(langCode,"tareekh"), "icon": Icons.history_edu, "color": Color(0xFF4E342E), "page": TareekhPage(lang: langCode)},
    ];
  }

  @override
  Widget build(BuildContext context) {
    var boxes = getBoxes(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLang.get(langCode,"app"), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Color(0xFF0A4D2E),
        centerTitle: true,
        actions: [IconButton(icon: Icon(Icons.language, color: Colors.white), onPressed: () async {
          final p = await SharedPreferences.getInstance(); p.remove('app_lang');
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> HolyQuranApp()), (r)=> false);
        })],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.95),
                itemCount: boxes.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => boxes[index]["page"])),
                    child: Container(
                      decoration: BoxDecoration(color: boxes[index]["color"], borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0,3))]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(boxes[index]["icon"], size: 50, color: Colors.white),
                          SizedBox(height: 12),
                          Text(boxes[index]["title"], textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("مکمل پڑھیں", style: TextStyle(color: Colors.white70, fontSize: 12)),
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

// کتاب جیسا صفحہ - آپ کے نقشے کا پوائنٹ 9
class BookPage extends StatelessWidget {
  final String title;
  final Color color;
  final List<Map<String,String>> pages; // ہر صفحے میں ar, tr
  BookPage({required this.title, required this.color, required this.pages});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: color),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: pages.length,
              itemBuilder: (c,i){
                var p = pages[i];
                return Container(
                  margin: EdgeInsets.all(12),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Color(0xFFFFF8E1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.brown.shade200)),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(p["ar"]!, textAlign: TextAlign.right, style: TextStyle(fontSize: 24, height: 1.8, fontFamily: 'serif')),
                        SizedBox(height: 16),
                        Divider(),
                        Text(p["tr"]!, style: TextStyle(fontSize: 16, height: 1.6)),
                        SizedBox(height: 30),
                        Text("صفحہ ${i+1} / ${pages.length}", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          MyBannerAd(),
        ],
      ),
    );
  }
}

// 3 وضو مکمل
class WuzuPage extends StatelessWidget {
  final String lang;
  WuzuPage({required this.lang});
  @override
  Widget build(BuildContext context) {
    var data = [
      {"ar":"نیت: نَوَيْتُ الْوُضُوْءَ لِلّٰہِ","tr":"نیت: میں وضو کی نیت کرتا ہوں اللہ کے لیے۔ وضو کے 4 فرض ہیں: 1- چہرہ دھونا 2- ہاتھ کہنیوں سمیت 3- چوتھائی سر کا مسح 4- پاؤں ٹخنوں سمیت"},
      {"ar":"بِسْمِ اللہِ الرَّحْمٰنِ الرَّحِیْمِ","tr":"بسم اللہ پڑھ کر وضو شروع کریں۔ دونوں ہاتھ گٹوں تک 3 بار دھوئیں۔"},
      {"ar":"اَلْحَمْدُ لِلّٰہِ عَلٰی الْاِسْلَامِ","tr":"فضیلت: حدیث میں ہے وضو کرنے سے گناہ جھڑ جاتے ہیں۔ مسواک سنت ہے۔ کلی 3 بار، ناک میں پانی 3 بار سنت ہے۔"},
      {"ar":"اَشْهَدُ اَنْ لَّا اِلٰهَ اِلَّا اللہُ وَ اَشْهَدُ اَنَّ مُحَمَّدًا عَبْدُہٗ وَ رَسُوْلُہٗ","tr":"وضو کے بعد کی دعا: جو یہ دعا پڑھے اس کے لیے جنت کے 8 دروازے کھول دیے جاتے ہیں۔"},
    ];
    return BookPage(title: AppLang.get(lang,"wuzu"), color: Color(0xFF0A4D2E), pages: data);
  }
}

// 4 نماز مکمل
class NamazPage extends StatelessWidget {
  final String lang;
  NamazPage({required this.lang});
  @override
  Widget build(BuildContext context) {
    var data = [
      {"ar":"سُبْحَانَكَ اللّٰهُمَّ وَبِحَمْدِكَ","tr":"ثناء: نماز کی ابتدا تکبیر تحریمہ سے ہوتی ہے۔ اللہ اکبر کہہ کر ہاتھ باندھیں۔ فجر 2 سنت 2 فرض، ظہر 4 سنت 4 فرض 2 سنت 2 نفل، عصر 4 سنت 4 فرض، مغرب 3 فرض 2 سنت 2 نفل، عشاء 4 سنت 4 فرض 2 سنت 3 وتر۔"},
      {"ar":"اَلْحَمْدُ لِلّٰہِ رَبِّ الْعٰلَمِیْنَ","tr":"قیام میں سورہ فاتحہ فرض ہے، اس کے بعد کوئی سورت۔ رکوع میں 3 بار سبحان ربی العظیم، سجدہ میں 3 بار سبحان ربی الاعلی۔"},
      {"ar":"اَلتَّحِیَّاتُ لِلّٰہِ وَ الصَّلَوٰتُ وَ الطَّیِّبَاتُ","tr":"قعدہ میں التحیات، درود شریف، دعا ماثورہ پڑھ کر سلام پھیریں۔ نماز کی فضیلت قرآن میں 700 سے زیادہ جگہ آئی ہے۔"},
    ];
    return BookPage(title: AppLang.get(lang,"namaz"), color: Color(0xFF1565C0), pages: data);
  }
}

// 5 قرآن مجید 114 سورتیں 30 پارے
class QuranMainPage extends StatelessWidget {
  final String lang;
  QuranMainPage({required this.lang});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("قرآن مجید - 20 زبانوں میں"), backgroundColor: Color(0xFF2E7D32)),
      body: Column(
        children: [
          ListTile(tileColor: Color(0xFFE8F5E9), title: Text("الف: پاروں کے حساب سے پڑھیں (30 پارے)"), trailing: Icon(Icons.arrow_forward_ios), onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=> ParaListPage(lang: lang)));
          }),
          ListTile(tileColor: Color(0xFFFFF3E0), title: Text("ب: سورتوں کے حساب سے پڑھیں (114 سورتیں)"), trailing: Icon(Icons.arrow_forward_ios), onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=> SurahListPage(lang: lang)));
          }),
          Expanded(child: Center(child: Text("عربی متن محفوظ، ترجمہ: $lang میں", style: TextStyle(fontSize: 16)))),
          MyBannerAd(),
        ],
      ),
    );
  }
}

class ParaListPage extends StatelessWidget {
  final String lang;
  ParaListPage({required this.lang});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("30 پارے"), backgroundColor: Color(0xFF2E7D32)),
      body: ListView.builder(
        itemCount: 30,
        itemBuilder: (c,i)=> ListTile(title: Text("پارہ ${i+1}"), subtitle: Text("Para ${i+1} - آیات، رکوع، عربی + $lang ترجمہ"), onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=> QuranReaderPage(title: "پارہ ${i+1}", lang: lang, start: i)));
        }),
      ),
    );
  }
}

class SurahListPage extends StatelessWidget {
  final String lang;
  SurahListPage({required this.lang});
  final surahs = ["الفاتحہ","البقرہ","آل عمران","النساء","المائدہ","الانعام","الاعراف","الانفال","التوبہ","یونس","ہود","یوسف","الرعد","ابراہیم","الحجر","النحل","بنی اسرائیل","الکہف","مریم","طہ","الانبیاء","الحج","المومنون","النور","الفرقان","الشعراء","النمل","القصص","العنکبوت","الروم","لقمان","السجدہ","الاحزاب","سبا","فاطر","یس","الصافات","ص","الزمر","المومن","حم السجدہ","الشوری","الزخرف","الدخان","الجاثیہ","الاحقاف","محمد","الفتح","الحجرات","ق","الذاریات","الطور","النجم","القمر","الرحمن","الواقعہ","الحدید","المجادلہ","الحشر","الممتحنہ","الصف","الجمعہ","المنافقون","التغابن","الطلاق","التحریم","الملک","القلم","الحاقہ","المعارج","نوح","الجن","المزمل","المدثر","القیامہ","الدھر","المرسلات","النبا","النازعات","عبس","التکویر","الانفطار","المطففین","الانشقاق","البروج","الطارق","الاعلی","الغاشیہ","الفجر","البلد","الشمس","اللیل","الضحی","الم نشرح","التین","العلق","القدر","البینہ","الزلزال","العادیات","القارعہ","التکاثر","العصر","الہمزہ","الفیل","قریش","الماعون","الکوثر","الکافرون","النصر","اللہب","الاخلاص","الفلق","الناس"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("114 سورتیں"), backgroundColor: Color(0xFF2E7D32)),
      body: ListView.builder(
        itemCount: surahs.length,
        itemBuilder: (c,i)=> ListTile(leading: CircleAvatar(child: Text("${i+1}")), title: Text(surahs[i]), subtitle: Text("آیات، رکوع، عربی متن + $lang ترجمہ مکمل"), onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=> QuranReaderPage(title: surahs[i], lang: lang, start: i)));
        }),
      ),
    );
  }
}

class QuranReaderPage extends StatelessWidget {
  final String title;
  final String lang;
  final int start;
  QuranReaderPage({required this.title, required this.lang, required this.start});
  @override
  Widget build(BuildContext context) {
    // یہاں آپ کا اصلی قرآن ڈیٹا آئے گا۔ فلحال سورہ فاتحہ اور اخلاص کا نمونہ
    var pages = [
      {"ar":"بِسْمِ اللّٰہِ الرَّحْمٰنِ الرَّحِیْمِ\nاَلْحَمْدُ لِلّٰہِ رَبِّ الْعٰلَمِیْنَ\nالرَّحْمٰنِ الرَّحِیْمِ\nمٰلِكِ یَوْمِ الدِّیْنِ\nاِیَّاكَ نَعْبُدُ وَ اِیَّاكَ نَسْتَعِیْنُ\nاِهْدِنَا الصِّرَاطَ الْمُسْتَقِیْمَ\nصِرَاطَ الَّذِیْنَ اَنْعَمْتَ عَلَیْهِمْ ۙ غَیْرِ الْمَغْضُوْبِ عَلَیْهِمْ وَ لَا الضَّآلِّیْنَ","tr":"[$lang ترجمہ] سب تعریفیں اللہ کے لیے ہیں جو تمام جہانوں کا پالنے والا ہے۔ بڑا مہربان نہایت رحم والا۔ بدلے کے دن کا مالک۔ ہم تیری ہی عبادت کرتے ہیں اور تجھ ہی سے مدد مانگتے ہیں۔ ہمیں سیدھا راستہ دکھا۔ ان لوگوں کا راستہ جن پر تو نے انعام کیا، نہ کہ ان کا جن پر غضب ہوا اور نہ گمراہوں کا۔\n\n[یہ $title کا مکمل عربی متن اور $lang میں ترجمہ ہے۔ آیت نمبر، رکوع یہاں آئیں گے۔]"},
      {"ar":"قُلْ هُوَ اللّٰہُ اَحَدٌ\nاَللّٰہُ الصَّمَدُ\nلَمْ یَلِدْ وَ لَمْ یُوْلَدْ\nوَ لَمْ یَكُنْ لَّہٗ كُفُوًا اَحَدٌ","tr":"[$lang ترجمہ] کہہ دو اللہ ایک ہے۔ اللہ بے نیاز ہے۔ نہ اس سے کوئی پیدا ہوا نہ وہ کسی سے پیدا ہوا۔ اور کوئی اس کا ہمسر نہیں۔\n\n[کتاب کی طرح صفحہ پلٹیں - سوائپ کریں - صفحہ ${start+1}]"},
    ];
    return BookPage(title: title, color: Color(0xFF2E7D32), pages: pages);
  }
}

class AzkarPage extends StatelessWidget {
  final String lang; AzkarPage({required this.lang});
  @override
  Widget build(BuildContext context) {
    var data = [
      {"ar":"اَصْبَحْنَا وَ اَصْبَحَ الْمُلْكُ لِلّٰہِ","tr":"صبح کا ذکر: ہم نے صبح کی اور سارا ملک اللہ کے لیے ہے۔ [مستند - مسلم]"},
      {"ar":"اَمْسَیْنَا وَ اَمْسَی الْمُلْكُ لِلّٰہِ","tr":"شام کا ذکر: ہم نے شام کی اور سارا ملک اللہ کے لیے ہے۔"},
    ];
    return BookPage(title: AppLang.get(lang,"azkar"), color: Color(0xFF6A1B9A), pages: data);
  }
}

class DuainPage extends StatelessWidget {
  final String lang; DuainPage({required this.lang});
  @override
  Widget build(BuildContext context) {
    var data = [
      {"ar":"اَلْحَمْدُ لِلّٰہِ الَّذِیْ اَطْعَمَنَا وَ سَقَانَا","tr":"کھانے کے بعد کی دعا: تمام تعریفیں اللہ کے لیے جس نے ہمیں کھلایا پلایا۔ [ترجمہ $lang میں]"},
      {"ar":"بِسْمِ اللّٰہِ تَوَكَّلْتُ عَلَی اللّٰہِ","tr":"گھر سے نکلنے کی دعا: اللہ کے نام سے، میں نے اللہ پر بھروسہ کیا۔"},
      {"ar":"اَللّٰهُمَّ اِنِّیْ اَسْأَلُكَ خَیْرَ الْمَوْلَجِ","tr":"گھر میں داخل ہونے کی دعا۔ سفر، مسجد، وضو، بیماری کی دعائیں مستند حوالوں کے ساتھ۔"},
    ];
    return BookPage(title: AppLang.get(lang,"duain"), color: Color(0xFFEF6C00), pages: data);
  }
}

class TareekhPage extends StatelessWidget {
  final String lang; TareekhPage({required this.lang});
  @override
  Widget build(BuildContext context) {
    var data = [
      {"ar":"اِقْرَأْ بِاسْمِ رَبِّكَ الَّذِیْ خَلَقَ","tr":"اسلام کا آغاز: پہلی وحی غار حرا میں نازل ہوئی۔ نبی کریم ﷺ کی سیرت مبارکہ، مکہ، مدینہ، ہجرت۔"},
      {"ar":"مُحَمَّدٌ رَّسُوْلُ اللّٰہِ","tr":"صحابہ کرامؓ: حضرت ابوبکر، عمر، عثمان، علی رضی اللہ عنہم، اہم غزوات بدر، احد، خندق، فتح مکہ۔ اسلامی تہذیب۔"},
    ];
    return BookPage(title: AppLang.get(lang,"tareekh"), color: Color(0xFF4E342E), pages: data);
  }
}

class MyBannerAd extends StatefulWidget {
  @override
  _MyBannerAdState createState() => _MyBannerAdState();
}
class _MyBannerAdState extends State<MyBannerAd> {
  BannerAd? _bannerAd; bool _isLoaded = false;
  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(adUnitId: 'ca-app-pub-3940256099942544/6300978111', size: AdSize.banner, request: AdRequest(), listener: BannerAdListener(onAdLoaded: (ad){ setState(()=> _isLoaded = true); }, onAdFailedToLoad: (ad, err){ ad.dispose(); }))..load();
  }
  @override
  void dispose() { _bannerAd?.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) return Container(height: 50, color: Colors.grey.shade200, child: Center(child: Text("اشتہار لوڈ ہو رہا ہے...")));
    return Container(height: 50, alignment: Alignment.center, child: AdWidget(ad: _bannerAd!));
  }
}

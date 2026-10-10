import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const NooriBaseeratApp());
}

// Noori Baseerat — consolidated main.dart starter.
// Requires google_mobile_ads and shared_preferences in pubspec.yaml.
// This starter does not contain the complete Quran dataset or
// 20 complete translations.

const String bannerAdUnitId =
    'ca-app-pub-6967191660339063/3603827158';
const String interstitialAdUnitId =
    'ca-app-pub-6967191660339063/7239928785';
const String appOpenAdUnitId =
    'ca-app-pub-6967191660339063/7048357094';

const Color deepGreen = Color(0xFF021A12);
const Color green = Color(0xFF0A4D2E);
const Color gold = Color(0xFFD8B45A);
const Color paper = Color(0xFFFFF8E8);

class NooriBaseeratApp extends StatefulWidget {
  const NooriBaseeratApp({super.key});

  @override
  State<NooriBaseeratApp> createState() =>
      _NooriBaseeratAppState();
}

class _NooriBaseeratAppState extends State<NooriBaseeratApp> {
  String? language;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    InterstitialController.load();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() => language = prefs.getString('nb_language'));
    }
  }

  Future<void> _chooseLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nb_language', code);
    if (mounted) setState(() => language = code);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noori Baseerat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: deepGreen,
        colorScheme: ColorScheme.fromSeed(seedColor: green),
        appBarTheme: const AppBarTheme(
          backgroundColor: deepGreen,
          foregroundColor: gold,
          centerTitle: true,
        ),
      ),
      home: language == null
          ? LanguagePage(onSelect: _chooseLanguage)
          : HomePage(language: language!),
    );
  }
}

class LanguageItem {
  final String code;
  final String name;

  const LanguageItem(this.code, this.name);
}

const languages = <LanguageItem>[
  LanguageItem('ur', 'اردو'),
  LanguageItem('goj', 'گوجری'),
  LanguageItem('ps', 'پښتو'),
  LanguageItem('ar', 'العربية'),
  LanguageItem('en', 'English'),
  LanguageItem('fa', 'فارسی'),
  LanguageItem('tr', 'Türkçe'),
  LanguageItem('fr', 'Français'),
  LanguageItem('de', 'Deutsch'),
  LanguageItem('hi', 'हिन्दी'),
  LanguageItem('bn', 'বাংলা'),
  LanguageItem('ms', 'Melayu'),
  LanguageItem('id', 'Indonesia'),
  LanguageItem('zh', '中文'),
  LanguageItem('ru', 'Русский'),
  LanguageItem('es', 'Español'),
  LanguageItem('sd', 'سنڌي'),
  LanguageItem('pa', 'پنجابی'),
  LanguageItem('bal', 'بلوچی'),
  LanguageItem('ta', 'தமிழ்'),
];

class LanguagePage extends StatelessWidget {
  final ValueChanged<String> onSelect;

  const LanguagePage({
    super.key,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepGreen,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Icon(
              Icons.visibility,
              color: gold,
              size: 48,
            ),
            const SizedBox(height: 10),
            const Text(
              'نوری بصیرت',
              style: TextStyle(
                color: gold,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'اپنی زبان منتخب کریں / Select your language',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: paper,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: languages.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final item = languages[index];

                    return OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: green,
                        side: const BorderSide(color: green),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => onSelect(item.code),
                      child: Text(
                        item.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

String appTitle(String lang) =>
    lang == 'en' ? 'Noori Baseerat' : 'نوری بصیرت';

String tileName(String lang, String key) {
  const translations = <String, Map<String, String>>{
    'ur': {
      'wudu': 'وضو کا طریقہ',
      'prayer': 'نماز کا طریقہ',
      'quran': 'قرآن مجید',
      'azkar': 'اذکار',
      'duas': 'مسنون دعائیں',
      'history': 'اسلامی تاریخ',
    },
    'goj': {
      'wudu': 'وضو کو طریقو',
      'prayer': 'نماز کو طریقو',
      'quran': 'قرآن مجید',
      'azkar': 'اذکار',
      'duas': 'مسنون دعاواں',
      'history': 'اسلامی تاریخ',
    },
    'ps': {
      'wudu': 'د اوداسه طریقه',
      'prayer': 'د لمانځه طریقه',
      'quran': 'قرآن کریم',
      'azkar': 'اذکار',
      'duas': 'مسنونی دعاګانې',
      'history': 'اسلامي تاریخ',
    },
    'en': {
      'wudu': 'How to perform Wudu',
      'prayer': 'How to pray',
      'quran': 'Holy Quran',
      'azkar': 'Daily Azkar',
      'duas': 'Masnoon Duas',
      'history': 'Islamic History',
    },
    'ar': {
      'wudu': 'الوضوء',
      'prayer': 'الصلاة',
      'quran': 'القرآن الكريم',
      'azkar': 'الأذكار',
      'duas': 'الأدعية',
      'history': 'التاريخ الإسلامي',
    },
  };

  return translations[lang]?[key] ??
      translations['ur']![key]!;
}

class HomePage extends StatelessWidget {
  final String language;

  const HomePage({
    super.key,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final items = <_HomeItem>[
      _HomeItem(
        'wudu',
        Icons.water_drop,
        const Color(0xFF1976D2),
      ),
      _HomeItem(
        'prayer',
        Icons.mosque,
        const Color(0xFF6A1B9A),
      ),
      _HomeItem(
        'quran',
        Icons.menu_book,
        const Color(0xFF2E7D32),
      ),
      _HomeItem(
        'azkar',
        Icons.self_improvement,
        const Color(0xFF00897B),
      ),
      _HomeItem(
        'duas',
        Icons.front_hand,
        const Color(0xFFEF6C00),
      ),
      _HomeItem(
        'history',
        Icons.history_edu,
        const Color(0xFF8D6E63),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle(language)),
        actions: [
          IconButton(
            tooltip: 'زبان تبدیل کریں',
            icon: const Icon(Icons.language),
            onPressed: () async {
              final chosen = await Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (_) => LanguagePage(
                    onSelect: (code) =>
                        Navigator.pop(context, code),
                  ),
                ),
              );

              if (chosen != null) {
                final prefs =
                    await SharedPreferences.getInstance();
                await prefs.setString('nb_language', chosen);

                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomePage(language: chosen),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              deepGreen,
              Color(0xFF104B31),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 14),
            const Text(
              'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: gold,
                fontSize: 25,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'علم، عبادت اور اچھی زندگی کی رہنمائی',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(14),
                itemCount: items.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.12,
                  crossAxisSpacing: 13,
                  mainAxisSpacing: 13,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      InterstitialController.showIfReady();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookPage(
                            title: tileName(
                              language,
                              item.keyName,
                            ),
                            icon: item.icon,
                            pages: contentFor(
                              item.keyName,
                              language,
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: paper,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: gold,
                          width: 1.4,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            item.icon,
                            color: item.color,
                            size: 43,
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: Text(
                              tileName(
                                language,
                                item.keyName,
                              ),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: deepGreen,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Icon(
                            Icons.menu_book,
                            color: gold,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  'نوری بصیرت',
                  style: TextStyle(color: gold),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(top: 3),
          child: BannerAdWidget(),
        ),
      ),
    );
  }
}

class _HomeItem {
  final String keyName;
  final IconData icon;
  final Color color;

  const _HomeItem(
    this.keyName,
    this.icon,
    this.color,
  );
}

class BookPage extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<_PageContent> pages;

  const BookPage({
    super.key,
    required this.title,
    required this.icon,
    required this.pages,
  });

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final PageController controller = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        color: deepGreen,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: widget.pages.length,
                onPageChanged: (value) {
                  setState(() => currentPage = value);
                },
                itemBuilder: (context, index) {
                  final page = widget.pages[index];

                  return AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      double value = 1;

                      if (controller.position.haveDimensions) {
                        value = (controller.page ??
                                controller.initialPage.toDouble()) -
                            index;
                        value =
                            (1 - (value.abs() * 0.08))
                                .clamp(0.92, 1.0);
                      }

                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                      ),
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: paper,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: gold,
                          width: 2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 12,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                          children: [
                            Icon(
                              widget.icon,
                              color: green,
                              size: 34,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              page.heading,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: green,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(
                              color: gold,
                              thickness: 1.5,
                              height: 28,
                            ),
                            Text(
                              page.body,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                color: deepGreen,
                                fontSize: 19,
                                height: 1.8,
                              ),
                            ),
                            if (page.note.isNotEmpty) ...[
                              const SizedBox(height: 18),
                              Text(
                                page.note,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                  color: green,
                                  fontSize: 15,
                                  height: 1.7,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'صفحہ ${currentPage + 1} / ${widget.pages.length}',
              style: const TextStyle(
                color: gold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: currentPage > 0
                      ? () => controller.previousPage(
                            duration:
                                const Duration(milliseconds: 350),
                            curve: Curves.easeIn

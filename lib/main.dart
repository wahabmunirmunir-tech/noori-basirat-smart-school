import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

// ============ زبان ============
class AppLang extends ChangeNotifier {
  String _code='en'; String get code=>_code;
  Map<String,Map<String,String>> t={
    'ur':{'title':'Holy Quran','resume':'Resume','juz':'Juz Index','surah':'Surah Index','goto':'Go to page #','book':'Bookmarks','set':'Settings','dev':'Developed by: FanzeTech'},
    'en':{'title':'Holy Quran','resume':'Resume','juz':'Juz Index','surah':'Surah Index','goto':'Go to page #','book':'Bookmarks','set':'Settings','dev':'Developed by: FanzeTech'},
  };
  AppLang(){_load();}
  void _load() async {final p=await SharedPreferences.getInstance(); _code=p.getString('lang')??'en'; notifyListeners();}
  void change(String c) async {_code=c; final p=await SharedPreferences.getInstance(); await p.setString('lang', c); notifyListeners();}
  String tr(String k)=> t[_code]![k]??k;
}

// ============ ایڈز ============
class AdM {
  static InterstitialAd? ad;
  static void load(){
    InterstitialAd.load(
      adUnitId:'ca-app-pub-6967191660339063/7048357094',
      request:const AdRequest(),
      adLoadCallback:InterstitialAdLoadCallback(
        onAdLoaded:(a)=>ad=a,
        onAdFailedToLoad:(e){ ad=null; }
      )
    );
  }
  static void show(){ if(ad!=null){ ad!.show(); ad=null; load(); } }
}

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  AdM.load();
  runApp(ChangeNotifierProvider(create:(_)=>AppLang(), child: MyApp()));
}
class MyApp extends StatelessWidget { @override Widget build(BuildContext context){ return MaterialApp(debugShowCheckedModeBanner:false, home:Splash()); } }

// ============ SPLASH - ویڈیو جیسا ============
class Splash extends StatefulWidget { @override _SplashState createState()=>_SplashState(); }
class _SplashState extends State<Splash> {
  @override void initState(){ super.initState(); Future.delayed(const Duration(seconds:2),(){ if(mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder:(_)=>HomeMenu())); }); }
  @override Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFF0A3D1F),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(18),
          decoration: BoxDecoration(border: Border.all(color: const Color(0xFFC5B358), width:2), borderRadius: BorderRadius.circular(8)),
          child: Stack(
            children:[
              Container(color: const Color(0xFF0A3D1F)),
              Positioned.fill(child: CustomPaint(painter: BorderPainter())),
              Center(
                child: Column(mainAxisAlignment:MainAxisAlignment.center, children:[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(shape:BoxShape.circle, border:Border.all(color:const Color(0xFFC5B358))),
                    child: const Text('القرآن الكريم', style:TextStyle(fontSize:42, color:Color(0xFFD4AF37), fontWeight:FontWeight.bold), textAlign:TextAlign.center),
                  ),
                  const SizedBox(height:30),
                  const Text('Developed by: FanzeTech', style:TextStyle(color:Colors.white70, fontSize:12)),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class BorderPainter extends CustomPainter {
  @override void paint(Canvas c, Size s){
    var p=Paint()..color=const Color(0xFFC5B358)..style=PaintingStyle.stroke..strokeWidth=1.2;
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(8,8,s.width-16,s.height-16), const Radius.circular(4)), p);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}

// ============ HOME MENU - ویڈیو جیسا ============
class HomeMenu extends StatefulWidget { @override _HomeMenuState createState()=>_HomeMenuState(); }
class _HomeMenuState extends State<HomeMenu> {
  BannerAd? banner;
  @override void initState(){
    super.initState();
    banner=BannerAd(
      adUnitId:'ca-app-pub-6967191660339063/7048357094',
      size:AdSize.banner,
      request:const AdRequest(),
      listener:BannerAdListener(onAdLoaded:(ad){ setState((){}); })
    )..load();
  }
  @override void dispose(){ banner?.dispose(); super.dispose(); }
  @override Widget build(BuildContext context){
    final lang=Provider.of<AppLang>(context);
    List<Map<String,String>> btns=[
      {'t':lang.tr('resume'),'page':'resume'},
      {'t':lang.tr('juz'),'page':'juz'},
      {'t':lang.tr('surah'),'page':'surah'},
      {'t':lang.tr('goto'),'page':'goto'},
      {'t':lang.tr('book'),'page':'book'},
      {'t':lang.tr('set'),'page':'set'},
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: const Color(0xFF0B5D2A), title:Text(lang.tr('title')), centerTitle:true),
      bottomNavigationBar: banner!=null? SizedBox(height:50, child:AdWidget(ad:banner!)):null,
      body: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFF0B5D2A), width:1.5), borderRadius: BorderRadius.circular(6)),
        child: Column(
          children:[
            Container(height:30, decoration:BoxDecoration(color:const Color(0xFF0B5D2A).withOpacity(0.1)), child:const Center(child:Icon(Icons.star, color:Color(0xFF0B5D2A), size:14))),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: btns.length,
                separatorBuilder: (_,__ )=> const SizedBox(height:10),
                itemBuilder: (c,i){
                  return GestureDetector(
                    onTap:(){
                      AdM.show();
                      if(btns[i]['page']=='surah') Navigator.push(c, MaterialPageRoute(builder:(_)=>SurahIndex()));
                      if(btns[i]['page']=='juz') Navigator.push(c, MaterialPageRoute(builder:(_)=>JuzIndex()));
                      if(btns[i]['page']=='resume') Navigator.push(c, MaterialPageRoute(builder:(_)=>QuranReader(startPage: 1)));
                    },
                    child: Container(
                      height:55,
                      decoration: BoxDecoration(color: const Color(0xFF0B3D1F), borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFFC5B358))),
                      child: Center(child: Text(btns[i]['t']!, style:const TextStyle(color:Colors.white, fontWeight:FontWeight.bold))),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height:10, child:Center(child:Text('Developed by: FanzeTech', style:TextStyle(fontSize:10, color:Colors.grey)))),
          ],
        ),
      ),
    );
  }
}

// ============ SURAH INDEX ============
class SurahIndex extends StatelessWidget {
  final List<Map<String,String>> surahs=[
    {"no":"1","en":"Al-Fatihah","ar":"سورة الفاتحة","page":"2"},
    {"no":"2","en":"Al-Baqarah","ar":"سورة البقرة","page":"3"},
    {"no":"3","en":"Al-'Imran","ar":"سورة ال عمران","page":"46"},
    {"no":"4","en":"An-Nisa'","ar":"سورة النساء","page":"70"},
    {"no":"5","en":"Al-Maidah","ar":"سورة المائدة","page":"97"},
    {"no":"6","en":"Al-An'am","ar":"سورة الأنعام","page":"116"},
    {"no":"7","en":"Al-A'raf","ar":"سورة الأعراف","page":"137"},
    {"no":"8","en":"Al-Anfal","ar":"سورة الأنفال","page":"160"},
    {"no":"9","en":"At-Tawbah","ar":"سورة التوبة","page":"169"},
    {"no":"10","en":"Yunus","ar":"سورة يونس","page":"188"},
    {"no":"11","en":"Hud","ar":"سورة هود","page":"201"},
    {"no":"12","en":"Yusuf","ar":"سورة يوسف","page":"215"},
  ];
  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF0B5D2A), title:const Text('Surah Index')),
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(border: Border.all(color:const Color(0xFF0B5D2A)), borderRadius:BorderRadius.circular(8)),
        child: ListView.builder(
          itemCount: 114,
          itemBuilder: (c,i){
            var s = i<surahs.length? surahs[i] : {"no":"${i+1}","en":"Surah ${i+1}","ar":"سورة","page":"${200+i}"};
            return Container(
              margin: const EdgeInsets.symmetric(horizontal:6, vertical:3),
              decoration: BoxDecoration(color: const Color(0xFF0B3D1F), borderRadius: BorderRadius.circular(3)),
              child: ListTile(
                onTap:(){ AdM.show(); Navigator.push(c, MaterialPageRoute(builder:(_)=>QuranReader(startPage: int.parse(s['page']!)))); },
                title: Text('${s['no']} - ${s['en']}', style:const TextStyle(color:Colors.white, fontSize:13)),
                subtitle: Text('Page no. ${s['page']}', style:const TextStyle(color:Colors.white70, fontSize:10)),
                trailing: Text(s['ar']!, style:const TextStyle(color:Colors.white, fontSize:14)),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============ JUZ INDEX ============
class JuzIndex extends StatelessWidget {
  final List<Map<String,String>> juz=[
    {"no":"1","en":"Alaf Lam Meem","ar":"الم","page":"2"},
    {"no":"2","en":"Sayaqool","ar":"سيقول","page":"22"},
    {"no":"3","en":"Tilkal Rusull","ar":"تلك الرسل","page":"42"},
    {"no":"4","en":"Lan Tana Loo","ar":"لن تنالوا","page":"62"},
    {"no":"5","en":"Wal Mohsanat","ar":"والمحصنت","page":"82"},
    {"no":"6","en":"La Yuhibbullah","ar":"لا يحب الله","page":"102"},
    {"no":"7","en":"Wa Iza Samiu","ar":"وإذا سمعوا","page":"121"},
    {"no":"8","en":"Wa Lau Annana","ar":"ولو أننا","page":"142"},
    {"no":"9","en":"Qalal Malao","ar":"قال الملأ","page":"162"},
    {"no":"10","en":"Wa A'lamu","ar":"واعلموا","page":"182"},
    {"no":"11","en":"Yatazeroon","ar":"يعتذرون","page":"201"},
    {"no":"12","en":"Wa Mamin Da'abat","ar":"وما من دابة","page":"221"},
    {"no":"13","en":"Wa Ma Ubrioo","ar":"وما أبرئ","page":"242"},
    {"no":"14","en":"Rubama","ar":"ربما","page":"262"},
    {"no":"15","en":"Subhanallazi","ar":"سبحن الذي","page":"282"},
  ];
  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF0B5D2A), title:const Text('Juz Index')),
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(border: Border.all(color:const Color(0xFF0B5D2A)), borderRadius:BorderRadius.circular(8)),
        child: ListView.builder(
          itemCount: 30,
          itemBuilder: (c,i){
            var j = i<juz.length? juz[i] : {"no":"${i+1}","en":"Juz ${i+1}","ar":"جزء","page":"${(i+1)*20}"};
            return Container(
              margin: const EdgeInsets.symmetric(horizontal:6, vertical:3),
              decoration: BoxDecoration(color: const Color(0xFF0B3D1F), borderRadius: BorderRadius.circular(3)),
              child: ListTile(
                onTap:(){ AdM.show(); Navigator.push(c, MaterialPageRoute(builder:(_)=>QuranReader(startPage: int.parse(j['page']!)))); },
                title: Text('${j['no']} - ${j['en']}', style:const TextStyle(color:Colors.white, fontSize:13)),
                subtitle: Text('Page no. ${j['page']}', style:const TextStyle(color:Colors.white70, fontSize:10)),
                trailing: Text(j['ar']!, style:const TextStyle(color:Colors.white, fontSize:14)),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============ QURAN READER ============
class QuranReader extends StatefulWidget { final int startPage; QuranReader({required this.startPage}); @override _QuranReaderState createState()=> _QuranReaderState(); }
class _QuranReaderState extends State<QuranReader> {
  late PageController pc;
  @override void initState(){ super.initState(); pc=PageController(initialPage: widget.startPage.clamp(0, 603)); _save(); }
  void _save() async { final p=await SharedPreferences.getInstance(); await p.setInt('last_page', widget.startPage); }
  @override Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: pc,
        itemCount: 604,
        onPageChanged: (p){ if(p%5==0) AdM.show(); },
        itemBuilder: (c, idx){
          return Stack(
            children:[
              Container(color: Colors.white, child: Center(child: Column(mainAxisAlignment:MainAxisAlignment.center, children:[Text('صفحہ ${idx+1}', style:const TextStyle(fontSize:10, color:Colors.grey)), const SizedBox(height:20), const Text('بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ\n\nالْحَمْدُ لِلّٰهِ رَبِّ الْعَالَمِيْنَ\nالرَّحْمٰنِ الرَّحِيْمِ\nمَالِكِ يَوْمِ الدِّيْنِ', style:TextStyle(fontSize:22, height:2), textAlign:TextAlign.center)]))),
              Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: QuranPageBorder()))),
              Positioned(bottom:0, left:0, right:0, child: Container(height:40, color: Colors.black.withOpacity(0.8), child: Row(mainAxisAlignment:MainAxisAlignment.spaceAround, children:[const Icon(Icons.settings, color:Colors.white, size:18), const Icon(Icons.bookmark, color:Colors.white, size:18), Text('${idx+1} / 604', style:const TextStyle(color:Colors.white, fontSize:12)), const Icon(Icons.share, color:Colors.white, size:18)]))),
            ],
          );
        },
      ),
    );
  }
}
class QuranPageBorder extends CustomPainter {
  @override void paint(Canvas canvas, Size size){
    var paint=Paint()..color=const Color(0xFF0B5D2A)..style=PaintingStyle.stroke..strokeWidth=3;
    canvas.drawRect(Rect.fromLTWH(4,4,size.width-8,size.height-50), paint);
    paint.strokeWidth=1; paint.color=const Color(0xFFD4AF37);
    canvas.drawRect(Rect.fromLTWH(12,12,size.width-24,size.height-66), paint);
  }
  @override bool shouldRepaint(covariant CustomPainter old)=>false;
}

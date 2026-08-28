
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

// ID DE TESTES OFICIAL DO GOOGLE - 'ca-app-pub-3940256099942544/6300978111'

Future<void> initAds() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
}

class AdsBanner extends StatefulWidget {
  final void Function(double height)? onHeight;
  const AdsBanner({this.onHeight, super.key});
  
  @override
  State<AdsBanner> createState() => _AdsBannerState();
}

class _AdsBannerState extends State<AdsBanner> {
  BannerAd? _banner;
  double _height = 0;

  @override
  void initState() {
    super.initState();
    _loadBanner();
  }

  Future<void> _loadBanner() async {
    // ✅ Obtém o tamanho adaptativo correto para a tela atual
    final AdSize? adSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(context).size.width.truncate(),
    );

    // ✅ Se não conseguir tamanho adaptativo, usa o banner padrão
    final size = adSize ?? AdSize.banner;

    _banner = BannerAd(
      size: size, // ✅ Tamanho dinâmico e correto
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // TESTE, troque no release!
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _height = _banner!.size.height.toDouble();
          });
          widget.onHeight?.call(_height); // ✅ Reporta a altura real
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          _banner?.dispose();
          _banner = null;
          widget.onHeight?.call(0); // ✅ Reporta altura 0 se falhar
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_banner == null) return const SizedBox.shrink();
    
    return SizedBox(
      width: _banner!.size.width.toDouble(), // ✅ Largura correta
      height: _height, // ✅ Altura correta (não mais fixa em 52)
      child: AdWidget(ad: _banner!),
    );
  }
}
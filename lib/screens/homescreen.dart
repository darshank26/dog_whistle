import 'package:dog_whistle/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share/share.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:sound_generator/sound_generator.dart';
import 'package:sound_generator/waveTypes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../AdHelper/adshelper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isPlaying = false;
  double frequency = 20;
  double balance = -1;
  double volume = 1;
  waveTypes waveType = waveTypes.SINUSOIDAL;
  int sampleRate = 96000;
  List<int>? oneCycleData;


  late BannerAd _bannerAd;

  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    isPlaying = false;

    SoundGenerator.init(sampleRate);

    SoundGenerator.onIsPlayingChanged.listen((value) {
      setState(() {
        isPlaying = value;
      });
    });

    SoundGenerator.onOneCycleDataHandler.listen((value) {
      setState(() {
        oneCycleData = value;
      });
    });

    SoundGenerator.setAutoUpdateOneCycleSample(true);
    //Force update for one time
    SoundGenerator.refreshOneCycleData();


    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitIdOfHomeScreen,
      request: AdRequest(),
      size: AdSize.largeBanner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ksplashback,
        centerTitle: true,
        title: Text(
            "Dog Whistle" ,
            style: GoogleFonts.openSans(textStyle: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w600,))
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: handleClick,
            color: Colors.white,
            itemBuilder: (BuildContext context) {
              return {'Share', 'Rate Us', 'More Apps'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),

        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:50.0),
            child: Container(
                width: double.infinity,
                height: 330,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SleekCircularSlider(
                        appearance: CircularSliderAppearance(
                          size: 300,
                            customWidths: CustomSliderWidths(progressBarWidth:15,trackWidth:20,)),
                        min: 20,
                        max: 20000,
                        initialValue: this.frequency,
                        onChange: (double value) {
                          setState(() {
                            this.frequency = value.toDouble();
                            SoundGenerator.setFrequency(
                                this.frequency);
                          });

                        },
                        onChangeStart: (double startValue) {
                          // callback providing a starting value (when a pan gesture starts)
                        },
                        onChangeEnd: (double endValue) {
                          // ucallback providing an ending value (when a pan gesture ends)
                        },
                      ),
                    ])),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
                radius: 40,
                backgroundColor: ksplashback,
                child: IconButton(
                    icon :isPlaying ? Icon(
                          Icons.stop, color: Colors.white, size: 50,
                    ) :  Icon(Icons.play_arrow,color: Colors.white,size: 50,),
                    onPressed: () {
                      isPlaying
                          ? SoundGenerator.stop()
                          : SoundGenerator.play();
                    })),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
                "First Click on Play button, then slide the frequency slider" ,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(textStyle: TextStyle(
                  fontSize: 18,
                  color: ksplashback,
                  fontWeight: FontWeight.w600,))
            ),
          ),


        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isBannerAdReady)
            Container(
              width: _bannerAd.size.width.toDouble(),
              height: _bannerAd.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd),
            ),
        ],
      ),
    );
  }


  void launchMoreApps() async {
    const url = 'https://play.google.com/store/apps/developer?id=Darshan+Komu';  // Replace with your desired URL
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void launchPlay() async {
    LaunchReview.launch(
      androidAppId: androidAppIdValue,
      iOSAppId: iOSAppIdValue,);
  }

  void handleClick(String value) {
    switch (value) {
      case 'Share':
        {
          launchPlay();
        }
        case 'Rate us':
          {
            launchPlay();
          }
      case 'More Apps':
        {
          launchMoreApps();
        }

    }
  }

  @override
  void dispose() {
    super.dispose();
    SoundGenerator.release();
    _bannerAd.dispose();

  }



}

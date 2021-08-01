import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class AdManager {
    static InterstitialAd? interstitialAd;
    static bool isInterstitialAdReady = false;

    static RewardedAd? rewardedAd;
    static bool isRewardedAdReady = false;

	static String get appId {
		if (Platform.isAndroid) {
			// return 'ca-app-pub-3940256099942544~3347511713'; // Test
            return 'ca-app-pub-1936572611542740~3131891497';
		} else {
			throw UnsupportedError('Unsupported platform');
		}
	}

    static String interstitialAdUnitId() {
        if (Platform.isAndroid) {
            // return 'ca-app-pub-3940256099942544/1033173712'; // Test
            return 'ca-app-pub-1936572611542740/3222556688';
        } else {
            throw new UnsupportedError('Unsupported platform');
        }
    }

    static String get rewardedAdUnitId {
        if (Platform.isAndroid) {
            // return 'ca-app-pub-3940256099942544/5224354917'; // Test
            return 'ca-app-pub-1936572611542740/1397790381';
        } else {
            throw new UnsupportedError('Unsupported platform');
        }
    }


	static Future<InitializationStatus> initGoogleMobileAds() {
		return MobileAds.instance.initialize();
	}

    static void loadInterstitialAd() {
        InterstitialAd.load(
            adUnitId: AdManager.interstitialAdUnitId(),
            request: AdRequest(),
            adLoadCallback: InterstitialAdLoadCallback(
                onAdLoaded: (ad) {
                    interstitialAd = ad;

                    ad.fullScreenContentCallback = FullScreenContentCallback(
                        onAdDismissedFullScreenContent: (ad) { }
                    );

                    isInterstitialAdReady = true;
                },
                onAdFailedToLoad: (err) {
                    print('Failed to load an interstitial ad: ${err.message}');
                    isInterstitialAdReady = false;
                }
            )
        );
    }

	static void loadRewardedAd() {
		RewardedAd.load(
			adUnitId: rewardedAdUnitId,
            request: AdRequest(),
            rewardedAdLoadCallback: RewardedAdLoadCallback(
                onAdLoaded: (ad) {
                    rewardedAd = ad;

                    ad.fullScreenContentCallback = FullScreenContentCallback(
                        onAdDismissedFullScreenContent: (ad) { }
                    );
                },
                onAdFailedToLoad: (err) {
                    print('Failed to load a rewarded ad: ${err.message}');
                }
            )
		);
    }

    static void showInterstitialAd() {
        AdManager.loadInterstitialAd();
        AdManager.interstitialAd?.show();
    }

    static void showRewardedAd(onUserEarnedReward) {
        AdManager.loadRewardedAd();
        AdManager.rewardedAd?.show(onUserEarnedReward: onUserEarnedReward);
    }
}
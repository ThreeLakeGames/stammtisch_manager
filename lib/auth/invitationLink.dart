import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class InvitationLink {
  static Future<String> createDynamicLink(String clubID) async {
    String _linkMessage;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      // The Dynamic Link URI domain. You can view created URIs on your Firebase console
      uriPrefix: 'https://stammtischmanager.page.link',
      // The deep Link passed to your application which you can use to affect change
      link: Uri.parse('https://www.example.com/invite/$clubID'),
      // Android application details needed for opening correct app on device/Play Store
      androidParameters: const AndroidParameters(
        packageName: "com.example.stammtisch_manager",
        minimumVersion: 1,
      ),
      // iOS application details needed for opening correct app on device/App Store
      iosParameters: const IOSParameters(
        bundleId: "com.stammtisch-manager",
        minimumVersion: '2',
      ),
    );

    final ShortDynamicLink shortLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);

    return shortLink.shortUrl.toString();
  }
}

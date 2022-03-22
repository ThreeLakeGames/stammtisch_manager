import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:stammtisch_manager/userProfile/custom_profile_screen.dart';

class ProfileOverview extends StatelessWidget {
  const ProfileOverview({Key? key}) : super(key: key);

  static const routeName = "/profile-overview";

  @override
  Widget build(BuildContext context) {
    return const CustomProfileScreen(
      avatarSize: 180,
      // actions: [IconButton(onPressed: (){}, icon: Ic)],
      providerConfigs: [
        EmailProviderConfiguration(),
        GoogleProviderConfiguration(
            clientId:
                "447187833757-lhr1sj31rgmshhoih39js1ebtb3gi1o6.apps.googleusercontent.com")
      ],
    );
  }
}

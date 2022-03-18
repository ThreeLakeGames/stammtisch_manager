import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
        child: LimitedBox(
          maxHeight: MediaQuery.of(context).size.height,
          child: SignInScreen(
            headerMaxExtent: 250,
            headerBuilder: (context, c, _) => Center(
              child: Flex(
                mainAxisSize: MainAxisSize.min,
                direction: Axis.vertical,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Willkommen!",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Flexible(
                    child: Image(
                      height: c.maxHeight,
                      // width: constraints.maxWidth,
                      image: const AssetImage("assets/bier_logo1.png"),
                    ),
                  ),
                ],
              ),
            ),
            providerConfigs: const [
              EmailProviderConfiguration(),
              GoogleProviderConfiguration(
                  clientId:
                      "447187833757-lhr1sj31rgmshhoih39js1ebtb3gi1o6.apps.googleusercontent.com"),
            ],
          ),
        ),
      ),
    );
  }
}

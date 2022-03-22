import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/cupertino.dart' hide Title;
import 'package:flutter/material.dart' hide Title;
import 'package:flutterfire_ui/auth.dart';
import 'package:flutterfire_ui/i10n.dart';

class CustomProfileScreen extends StatefulWidget {
  final List<ProviderConfiguration> providerConfigs;
  final List<Widget> children;
  final FirebaseAuth? auth;
  final Color? avatarPlaceholderColor;
  final ShapeBorder? avatarShape;
  final double? avatarSize;
  final List<FlutterFireUIAction>? actions;

  const CustomProfileScreen({
    Key? key,
    required this.providerConfigs,
    this.auth,
    this.avatarPlaceholderColor,
    this.avatarShape,
    this.avatarSize,
    this.children = const [],
    this.actions,
  }) : super(key: key);

  @override
  State<CustomProfileScreen> createState() => _CustomProfileScreenState();
}

class _CustomProfileScreenState extends State<CustomProfileScreen> {
  Future<void> _logout(BuildContext context) async {
    await (widget.auth ?? FirebaseAuth.instance).signOut();
    final action = FlutterFireUIAction.ofType<SignedOutAction>(context);

    action?.callback(context);
  }

  Future<bool> _reauthenticate(BuildContext context) {
    return showReauthenticateDialog(
      context: context,
      providerConfigs: widget.providerConfigs,
      auth: widget.auth,
      onSignedIn: () => Navigator.of(context).pop(true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = FlutterFireUILocalizations.labelsOf(context);
    final isCupertino = CupertinoUserInterfaceLevel.maybeOf(context) != null;
    final platform = Theme.of(context).platform;
    final _auth = widget.auth ?? FirebaseAuth.instance;
    final _user = _auth.currentUser!;

    final linkedProviders = widget.providerConfigs
        .where((config) => _user.isProviderLinked(config.providerId))
        .toList();

    final availableProviders = widget.providerConfigs
        .where((config) => !_user.isProviderLinked(config.providerId))
        .where((config) => config.isSupportedPlatform(platform))
        .toList();

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          child: UserAvatar(
            auth: widget.auth,
            placeholderColor: widget.avatarPlaceholderColor,
            shape: widget.avatarShape,
            size: widget.avatarSize,
          ),
        ),
        const SizedBox(height: 16),
        Align(child: EditableUserDisplayName(auth: widget.auth)),
        if (linkedProviders.isNotEmpty) ...[
          const SizedBox(height: 32),
          LinkedProvidersRow(
            auth: widget.auth,
            providerConfigs: linkedProviders,
          ),
        ],
        if (availableProviders.isNotEmpty) ...[
          const SizedBox(height: 32),
          AvailableProvidersRow(
            auth: widget.auth,
            providerConfigs: availableProviders,
            onProviderLinked: () => setState(() {}),
          ),
        ],
        ...widget.children,
        const SizedBox(height: 16),
        DeleteAccountButton(
          auth: widget.auth,
          onSignInRequired: () {
            return _reauthenticate(context);
          },
        ),
      ],
    );
    final body = Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 500) {
              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: content,
              );
            } else {
              return content;
            }
          },
        ),
      ),
    );

    if (isCupertino) {
      return FlutterFireUIActions(
        actions: widget.actions ?? const [],
        child: Builder(
          builder: (context) => CupertinoPageScaffold(
            child: SafeArea(child: SingleChildScrollView(child: body)),
          ),
        ),
      );
    } else {
      return FlutterFireUIActions(
        actions: widget.actions ?? const [],
        child: Builder(
          builder: (context) => Scaffold(
            body: SafeArea(child: SingleChildScrollView(child: body)),
          ),
        ),
      );
    }
  }
}

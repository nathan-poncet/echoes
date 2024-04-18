import 'package:echoes/src/common_widgets/data_display/icon/svg_icon.dart';
import 'package:echoes/src/constants/app_sizes.dart';
import 'package:echoes/src/constants/paddings.dart';
import 'package:echoes/src/features/auth/presentation/auth_screen.dart';
import 'package:echoes/src/features/auth/presentation/auth_screen_controller.dart';
import 'package:echoes/src/utils/modal_bottom_sheet/show_modal_bottom_sheet_full_height_with_scroll.dart';
import 'package:flutter/material.dart';

const tabs = [
  Tab(text: "Inscription"),
  Tab(text: "Connexion"),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFFCB69F), Color(0xFFFFECD2)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: Paddings.page,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SvgIcon("assets/icons/wave.svg", size: 100),
                      gapH24,
                      Text(
                        'Listen world vocal',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Une application qui permet aux utilisateurs de laisser des messages vocaux géolocalisés à travers le monde',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black.withOpacity(0.6)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton(
                      onPressed: () => showModalBottomSheetFullHeightWithScroll(
                        context: context,
                        builder: (ScrollController scrollController) => AuthScreen(scrollController: scrollController, initialType: AuthScreenType.signUp),
                      ),
                      child: const Text('Crée un compte'),
                    ),
                    gapH8,
                    OutlinedButton(
                      onPressed: () => showModalBottomSheetFullHeightWithScroll(
                        context: context,
                        builder: (ScrollController scrollController) => AuthScreen(scrollController: scrollController, initialType: AuthScreenType.signIn),
                      ),
                      child: const Text('Se connecter'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

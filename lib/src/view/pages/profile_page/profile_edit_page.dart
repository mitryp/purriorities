import 'package:flutter/cupertino.dart';

import '../../widgets/authorizer.dart';
import '../../widgets/layouts/layout_selector.dart';
import '../../widgets/layouts/mobile.dart';

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context) {
      return Authorizer(
        child: LayoutSelector(
          mobileLayoutBuilder: (_) => const _ProfileEditPageMobileLayout(),
        ),
      );
  }
}

class _ProfileEditPageMobileLayout extends StatelessWidget {
  const _ProfileEditPageMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
      return MobileLayout.child(child: Column());
  }
}
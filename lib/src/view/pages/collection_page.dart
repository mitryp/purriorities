import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/layouts/layout_selector.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});
  
  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  @override
  Widget build(BuildContext context) {
      return LayoutSelector(
          mobileLayoutBuilder: (context) => const MobileCollection(),
          desktopLayoutBuilder: (context) => const Placeholder(),
      );
  }
}

class MobileCollection extends StatelessWidget {
  const MobileCollection({super.key});

  @override
  Widget build(BuildContext context) {
      return Placeholder();
  }
}
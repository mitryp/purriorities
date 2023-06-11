import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/enums/communication_data_status.dart';
import '../../data/models/quest.dart';
import '../../data/models/quest_category.dart';
import '../../data/util/notifier_wrapper.dart';
import '../../data/util/validators.dart';
import '../../services/http/util/fetch_service_bundle.dart';
import '../../typedefs.dart';
import '../widgets/error_snack_bar.dart';
import '../widgets/layouts/form_layout.dart';
import '../widgets/layouts/layout_selector.dart';
import '../widgets/layouts/mobile.dart';
import '../widgets/progress_indicator_button.dart';

class CategoriesEditPage extends StatelessWidget {
  final QuestCategory? category;

  const CategoriesEditPage({this.category, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotifierWrapper(category ?? const QuestCategory.empty()),
      child: LayoutSelector(
        mobileLayoutBuilder: (_) => _MobileCategoriesEditPage(isEditing: category != null),
        desktopLayoutBuilder: (_) => const Placeholder(),
      ),
    );
  }
}

class _MobileCategoriesEditPage extends StatefulWidget {
  final bool isEditing;

  const _MobileCategoriesEditPage({required this.isEditing, super.key});

  @override
  State<_MobileCategoriesEditPage> createState() => _MobileCategoriesEditPageState();
}

class _MobileCategoriesEditPageState extends State<_MobileCategoriesEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  NotifierWrapper<QuestCategory> get categoryWrapper =>
      context.read<NotifierWrapper<QuestCategory>>();

  QuestCategory get category => categoryWrapper.data;

  set category(QuestCategory category) => categoryWrapper.data = category;

  @override
  Widget build(BuildContext context) {
    return MobileLayout.child(
      appBar: AppBar(
        title: Text('${widget.isEditing ? 'Редагування' : 'Створення'} категорії'),
      ),
      child: Card(
        child: FormLayout(
          form: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: TextFormField(
                    initialValue: category.name,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: notEmpty,
                    onChanged: (name) => category = category.copyWith(name: name),
                    decoration: const InputDecoration(labelText: 'Назва категорії'),
                  ),
                ),
              ],
            ),
          ),
          trailing: [
            const SizedBox(height: 16),
            ProgressIndicatorButton(
              buttonBuilder: OutlinedButton.new,
              onPressed: _processCategorySaving,
              child: const Text('Зберегти'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processCategorySaving() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final fetchService = context.read<FetchServiceBundle>().categoriesFetchService;

    final isEditing = widget.isEditing;
    final res = isEditing
        ? await fetchService.update(category.id, category)
        : await fetchService.create(category);

    if (!mounted) return;

    if (res.isSuccessful) {
      context.pop<CommunicationData>(
        (
          status: isEditing ? CommunicationDataStatus.updated : CommunicationDataStatus.created,
          data: res.result(),
        ),
      );

      return;
    }

    showErrorSnackBar(
      context: context,
      content: ErrorSnackBarContent(
        titleText: 'Не вдалось ${isEditing ? 'створити' : 'оновити'} категорю',
        subtitleText: 'Повідомлення від сервера: ${res.errorMessage}',
      ),
    );
  }
}

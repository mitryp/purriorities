import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/enums/communication_data_status.dart';
import '../../data/models/quest_category.dart';
import '../../services/http/util/fetch_result.dart';
import '../../services/http/util/fetch_service_bundle.dart';
import '../../typedefs.dart';
import '../dialogs/confirmation_dialog.dart';
import '../pages/categories_edit_page.dart';
import '../theme.dart';
import 'add_button.dart';
import 'error_snack_bar.dart';

class CategoriesDrawer extends StatefulWidget {
  final Callback<QuestCategory>? onCategorySelected;
  final Callback<QuestCategory>? onCategoryDeleted;
  final Callback<QuestCategory>? onCategoryUpdated;
  final Callback<QuestCategory>? onCategoryCreated;
  final bool popOnDelete;

  const CategoriesDrawer({
    this.onCategorySelected,
    this.onCategoryDeleted,
    this.onCategoryUpdated,
    this.onCategoryCreated,
    this.popOnDelete = false,
    super.key,
  });

  @override
  State<CategoriesDrawer> createState() => _CategoriesDrawerState();
}

class _CategoriesDrawerState extends State<CategoriesDrawer> with AutomaticKeepAliveClientMixin {
  late final FetchResult<List<QuestCategory>> _categoriesResult;
  late final List<QuestCategory> _categories;
  bool _areCategoriesLoaded = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final fetchService = context.read<FetchServiceBundle>().categoriesFetchService;

    _categoriesResult =
        await fetchService.getMany().then((res) => res.transform((res) => res.data));

    if (_categoriesResult.isSuccessful) {
      _categories = _categoriesResult.result();
    }

    setState(() => _areCategoriesLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Категорії'),
          automaticallyImplyLeading: false,
        ),
        floatingActionButton: AddButton(
          heroTag: 'categories-drawer-add',
          onPressed: _redirectToCategoryEdit,
        ),
        body: SafeArea(
          minimum: const EdgeInsets.all(8),
          child: Builder(
            builder: (context) {
              if (!_areCategoriesLoaded) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!_categoriesResult.isSuccessful) {
                return Center(
                  child: Text(
                    _categoriesResult.errorMessage,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                );
              }

              return ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];

                  return Slidable(
                    key: ValueKey(category.id),
                    enabled: !category.inbox,
                    endActionPane: ActionPane(
                      motion: const BehindMotion(),
                      children: [
                        SlidableAction(
                          icon: Icons.delete,
                          backgroundColor: Colors.red[400]!,
                          onPressed: (_) => _processCategoryDeletion(category),
                        ),
                        SlidableAction(
                          icon: Icons.edit,
                          backgroundColor: legendaryColor,
                          onPressed: (_) => _redirectToCategoryEdit(category),
                        ),
                      ],
                    ),
                    child: Card(
                      color: category.inbox ? Colors.grey[600]!.withOpacity(0.15) : null,
                      child: ListTile(
                        title: Text(category.name),
                        onTap: widget.onCategorySelected != null
                            ? () => _processCategorySelection(category)
                            : null,
                        trailing: !category.inbox ? const Icon(Icons.keyboard_arrow_left) : null,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _processCategoryDeletion(QuestCategory category) async {
    final fetchService = context.read<FetchServiceBundle>().categoriesFetchService;

    final isConfirmed = await showConfirmationDialog(
      context: context,
      title: 'Ви дійсно хочете видалити категорію "${category.name}"?',
      prompt: 'Квести цієї категорії будуть переміщені в категорію за замовчуванням',
      titleStyle: const TextStyle(fontSize: 17),
      promptStyle: const TextStyle(fontSize: 15),
      confirmLabelText: 'Так',
      denyLabelText: 'Ні',
    );

    if (!isConfirmed || !mounted) return;

    final res = await fetchService.delete(category.id);

    if (!mounted) return;

    if (!res.isSuccessful) {
      showErrorSnackBar(
        context: context,
        content: ErrorSnackBarContent(
          titleText: 'Під час видалення категорії сталася помилка',
          subtitleText: 'Повідомлення від сервера: ${res.errorMessage}',
        ),
      );
    } else {
      setState(() => _categories.removeWhere((e) => e.id == category.id));

      widget.onCategoryDeleted?.call(category);

      if (widget.popOnDelete) {
        context.pop((data: category, status: CommunicationDataStatus.deleted));
      }
    }
  }

  Future<void> _redirectToCategoryEdit([QuestCategory? category]) async {
    final commData = await Navigator.of(context).push<CommunicationData<QuestCategory>>(
      MaterialPageRoute(builder: (context) => CategoriesEditPage(category: category)),
    );

    if (!mounted || commData == null) return;

    final newCategory = commData.data!;

    setState(() {
      if (commData.status == CommunicationDataStatus.updated) {
        _categories.removeWhere((c) => c.id == category!.id);
      }
      _categories.add(newCategory);
    });

    (commData.status == CommunicationDataStatus.created
            ? widget.onCategoryCreated
            : widget.onCategoryUpdated)
        ?.call(newCategory);
  }

  void _processCategorySelection(QuestCategory category) {
    widget.onCategorySelected?.call(category);
    context.pop();
  }
}

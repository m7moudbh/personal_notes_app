import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/local_storage_service.dart';
import '../utils/constants.dart';
import '../utils/app_localizations.dart';
import 'category_notes_screen.dart';

String tr(BuildContext context, String key) {
  return AppLocalizations.of(context)!.translate(key);
}

class CategoriesScreen extends StatefulWidget {
  final ValueNotifier<int> refreshNotifier;
  final VoidCallback onRefresh;
  const CategoriesScreen({
    super.key,
    required this.refreshNotifier,
    required this.onRefresh,
  });

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> with AutomaticKeepAliveClientMixin {
  final LocalStorageService _storageService = LocalStorageService.instance;
  List<Category> _categories = [];
  bool _isLoading = true;
  bool _isSelectionMode = false;
  Set<int> _selectedCategories = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    widget.refreshNotifier.addListener(_onRefresh);
  }

  void _onRefresh() {
    if (mounted) {
      _loadCategories();
    }
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    final categories = await _storageService.getAllCategories();
    setState(() {
      _categories = categories;
      _isLoading = false;
    });
  }

  Future<void> _deleteCategory(int id) async {
    await _storageService.deleteCategory(id);
    _loadCategories();
    widget.onRefresh();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr(context, 'category_deleted')),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _deleteMultipleCategories() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr(context, 'delete_categories_title')),
        content: Text('${tr(context, 'delete_message')}\n${_selectedCategories.length} ${tr(context, 'delete_categories_message')}'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(tr(context, 'cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(tr(context, 'delete')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      for (int id in _selectedCategories) {
        await _storageService.deleteCategory(id);
      }
      setState(() {
        _isSelectionMode = false;
        _selectedCategories.clear();
      });
      _loadCategories();
      widget.onRefresh();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr(context, 'categories_deleted')),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showDeleteCategoryDialog(Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr(context, 'delete_category_title')),
        content: Text('${tr(context, 'delete_category_message')} "${category.name}"?\n${tr(context, 'delete_category_warning')}'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr(context, 'cancel')),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCategory(category.id!);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(tr(context, 'delete')),
          ),
        ],
      ),
    );
  }

  Color parseColor(String colorString) {
    return Color(int.parse(colorString.replaceAll('0x', ''), radix: 16));
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'note':
        return Icons.note;
      case 'work':
        return Icons.work;
      case 'school':
        return Icons.school;
      case 'person':
        return Icons.person;
      case 'lightbulb':
        return Icons.lightbulb;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'restaurant':
        return Icons.restaurant;
      case 'travel_explore':
        return Icons.travel_explore;
      default:
        return Icons.folder;
    }
  }

  Future<void> _showAddCategoryDialog() async {
    final nameController = TextEditingController();
    String selectedIcon = 'note';
    String selectedColor = '0xFF2196F3';

    final icons = [
      {'name': 'note', 'icon': Icons.note},
      {'name': 'work', 'icon': Icons.work},
      {'name': 'school', 'icon': Icons.school},
      {'name': 'person', 'icon': Icons.person},
      {'name': 'lightbulb', 'icon': Icons.lightbulb},
      {'name': 'shopping_cart', 'icon': Icons.shopping_cart},
      {'name': 'fitness_center', 'icon': Icons.fitness_center},
      {'name': 'restaurant', 'icon': Icons.restaurant},
      {'name': 'travel_explore', 'icon': Icons.travel_explore},
    ];

    final colors = [
      {'name': 'Blue', 'value': '0xFF2196F3', 'color': const Color(0xFF2196F3)},
      {'name': 'Purple', 'value': '0xFF9C27B0', 'color': const Color(0xFF9C27B0)},
      {'name': 'Green', 'value': '0xFF4CAF50', 'color': const Color(0xFF4CAF50)},
      {'name': 'Red', 'value': '0xFFE53935', 'color': const Color(0xFFE53935)},
      {'name': 'Orange', 'value': '0xFFFF9800', 'color': const Color(0xFFFF9800)},
      {'name': 'Teal', 'value': '0xFF009688', 'color': const Color(0xFF009688)},
    ];

    if (!mounted) return;


    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (stateContext, setDialogState) => AlertDialog(
          title: Text(tr(context, 'add_category')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: tr(context, 'category_name'),
                    border: const OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                Text(
                  tr(context, 'choose_icon'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: icons.map((icon) {
                    final isSelected = selectedIcon == icon['name'];
                    return InkWell(
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = icon['name'] as String;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          )
                              : null,
                        ),
                        child: Icon(icon['icon'] as IconData),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  tr(context, 'choose_color'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: colors.map((colorData) {
                    final isSelected = selectedColor == colorData['value'];
                    return InkWell(
                      onTap: () {
                        setDialogState(() {
                          selectedColor = colorData['value'] as String;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: colorData['color'] as Color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
                          boxShadow: isSelected
                              ? [
                            BoxShadow(
                              color: (colorData['color'] as Color).withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            )
                          ]
                              : null,
                        ),
                        child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // ← إرجاع false
              },
              child: Text(tr(context, 'cancel')),
            ),
            FilledButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  return;
                }

                final category = Category(
                  name: nameController.text.trim(),
                  icon: selectedIcon,
                  color: selectedColor,
                  createdDate: DateTime.now(),
                );


                await _storageService.createCategory(category);


                Navigator.of(dialogContext).pop(true);
              },
              child: Text(tr(context, 'save')),
            ),
          ],
        ),
      ),
    );


   // nameController.dispose();

    if (result == true && mounted) {
      _loadCategories();
      widget.onRefresh();
    }
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr(context, 'categories'),
          style: AppConstants.titleStyle,
        ),
        actions: [
          if (_isSelectionMode) ...[
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '${_selectedCategories.length}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.select_all),
              tooltip: tr(context, 'tooltip_select_all'),
              onPressed: () {
                setState(() {
                  if (_selectedCategories.length == _categories.length) {
                    _selectedCategories.clear();
                  } else {
                    _selectedCategories = _categories.map((c) => c.id!).toSet();
                  }
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: tr(context, 'tooltip_delete'),
              onPressed: _selectedCategories.isEmpty ? null : _deleteMultipleCategories,
            ),
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: tr(context, 'tooltip_cancel'),
              onPressed: () {
                setState(() {
                  _isSelectionMode = false;
                  _selectedCategories.clear();
                });
              },
            ),
          ] else ...[
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              tooltip: tr(context, 'more'),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onSelected: (value) {
                if (value == 'select_all') {
                  setState(() {
                    _isSelectionMode = true;
                    _selectedCategories = _categories.map((c) => c.id!).toSet();
                  });
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'select_all',
                  child: Row(
                    children: [
                      const Icon(Icons.checklist),
                      const SizedBox(width: 12),
                      Text(tr(context, 'select_all')),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _categories.isEmpty
          ? _buildEmptyState()
          : _buildCategoriesList(),
      floatingActionButton: _isSelectionMode
          ? null
          : FloatingActionButton.extended(
        onPressed: _showAddCategoryDialog,
        icon: const Icon(Icons.create_new_folder),
        label: Text(tr(context, 'add_category')),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 100,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            tr(context, 'no_categories'),
            style: AppConstants.titleStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tr(context, 'no_categories_desc'),
            style: AppConstants.bodyStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  String _getTranslatedCategoryName(Category category) {
    if (category.translationKey != null && category.translationKey!.isNotEmpty) {
      return tr(context, category.translationKey!);
    }
    return category.name;
  }

  Widget _buildCategoriesList() {
    return ListView.builder(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 80,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        final isSelected = _selectedCategories.contains(category.id);

        return FutureBuilder<int>(
          future: _storageService.getNotesCountInCategory(category.id!),
          builder: (context, snapshot) {
            final count = snapshot.data ?? 0;
            final categoryColor = parseColor(category.color);

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: isSelected ? 4 : 2,
              color: isSelected
                  ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
                  : null,
              child: ListTile(
                leading: _isSelectionMode
                    ? Checkbox(
                  value: isSelected,
                  onChanged: (_) {
                    setState(() {
                      if (isSelected) {
                        _selectedCategories.remove(category.id);
                        if (_selectedCategories.isEmpty) {
                          _isSelectionMode = false;
                        }
                      } else {
                        _selectedCategories.add(category.id!);
                      }
                    });
                  },
                )
                    : Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(category.icon),
                    color: categoryColor,
                  ),
                ),
                title: Text(
                  _getTranslatedCategoryName(category),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('$count ${tr(context, 'notes_count')}'),
                trailing: _isSelectionMode
                    ? null
                    : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: Theme.of(context).colorScheme.error,
                      onPressed: () => _showDeleteCategoryDialog(category),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
                onTap: () async {
                  if (_isSelectionMode) {
                    setState(() {
                      if (isSelected) {
                        _selectedCategories.remove(category.id);
                        if (_selectedCategories.isEmpty) {
                          _isSelectionMode = false;
                        }
                      } else {
                        _selectedCategories.add(category.id!);
                      }
                    });
                  } else {

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryNotesScreen(
                          category: category,
                            onNotesChanged: () {
                              _loadCategories();
                              widget.onRefresh();
                            }
                        ),
                      ),
                    );
                    _loadCategories();
                    widget.onRefresh();
                  }
                },
                onLongPress: () {
                  if (!_isSelectionMode) {
                    setState(() {
                      _isSelectionMode = true;
                      _selectedCategories.add(category.id!);
                    });
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
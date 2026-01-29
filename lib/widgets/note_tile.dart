import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note_model.dart';
import '../models/category_model.dart';
import '../services/local_storage_service.dart';
import '../utils/app_localizations.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback onDelete;
  final VoidCallback? onFavoriteToggle;
  final bool isSelected;
  final bool isSelectionMode;
  final bool showRemoveFromCategory;
  final VoidCallback? onRemoveFromCategory;

  const NoteTile({
    super.key,
    required this.note,
    required this.onTap,
    this.onLongPress,
    required this.onDelete,
    this.onFavoriteToggle,
    this.isSelected = false,
    this.isSelectionMode = false,
    this.showRemoveFromCategory = false,
    this.onRemoveFromCategory,
  });

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

  String _getTranslatedCategoryName(Category category, BuildContext context) {
    if (category.translationKey != null && category.translationKey!.isNotEmpty) {
      return AppLocalizations.of(context)!.translate(category.translationKey!);
    }
    return category.name;
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy - hh:mm a').format(note.createdDate);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : 2,
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
          : null,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (isSelectionMode) ...[
                    Checkbox(
                      value: isSelected,
                      onChanged: (_) => onTap(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],


                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          note.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: isSelected ? TextDecoration.underline : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),


                        Text(
                          note.content,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            height: 1.5,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),


                  if (!isSelectionMode) ...[

                    if (onFavoriteToggle != null)
                      IconButton(
                        icon: Icon(
                          note.isFavorite ? Icons.star : Icons.star_border,
                          color: note.isFavorite
                              ? Colors.amber
                              : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        ),
                        onPressed: onFavoriteToggle,
                        tooltip: note.isFavorite ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
                      ),

                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) {
                        if (value == 'remove' && onRemoveFromCategory != null) {
                          onRemoveFromCategory!();
                        } else if (value == 'delete') {
                          onDelete();
                        }
                      },
                      itemBuilder: (context) => [
                        if (showRemoveFromCategory && onRemoveFromCategory != null)
                          PopupMenuItem(
                            value: 'remove',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.folder_off_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                const Text('إزالة من المجموعة'),
                              ],
                            ),
                          ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              const SizedBox(width: 12),
                              const Text('حذف'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 12),


              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  if (note.categoryId != null) ...[
                    const SizedBox(width: 12),
                    FutureBuilder<Category?>(
                      future: LocalStorageService.instance.getCategory(note.categoryId!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          final category = snapshot.data!;
                          final categoryColor = parseColor(category.color);
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: categoryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: categoryColor.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getCategoryIcon(category.icon),
                                  size: 14,
                                  color: categoryColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _getTranslatedCategoryName(category, context),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: categoryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
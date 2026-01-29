import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/category_model.dart';
import '../models/note_model.dart';
import '../services/local_storage_service.dart';
import '../utils/constants.dart';
import '../utils/app_localizations.dart';
import '../widgets/note_tile.dart';
import 'add_edit_note_screen.dart';

String tr(BuildContext context, String key) {
  return AppLocalizations.of(context)!.translate(key);
}

class CategoryNotesScreen extends StatefulWidget {
  final Category category;
  final VoidCallback? onNotesChanged;

  const CategoryNotesScreen({
    super.key,
    required this.category,
    this.onNotesChanged,
  });

  @override
  State<CategoryNotesScreen> createState() => _CategoryNotesScreenState();
}

class _CategoryNotesScreenState extends State<CategoryNotesScreen> {
  final LocalStorageService _storageService = LocalStorageService.instance;
  List<Note> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    final notes = await _storageService.getNotesByCategory(widget.category.id!);
    setState(() {
      _notes = notes;
      _isLoading = false;
    });
  }

  Future<void> _deleteNote(int id) async {
    await _storageService.deleteNote(id);
    _loadNotes();
    widget.onNotesChanged?.call();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr(context, 'note_deleted')),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _toggleFavorite(Note note) async {
    await _storageService.toggleFavorite(note.id!, !note.isFavorite);
    _loadNotes();
    widget.onNotesChanged?.call();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            note.isFavorite
                ? tr(context, 'removed_from_favorites')
                : tr(context, 'added_to_favorites'),
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _removeFromCategory(Note note) async {
    final updatedNote = note.copyWith(categoryId: null);
    await _storageService.updateNote(updatedNote);
    _loadNotes();
    widget.onNotesChanged?.call();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr(context, 'note_removed_from_category')),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showDeleteDialog(Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr(context, 'delete_title')),
        content: Text(tr(context, 'delete_message')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr(context, 'cancel')),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteNote(note.id!);
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

  Future<void> _showAddNotesDialog() async {
    final allNotes = await _storageService.getAllNotes();
    final availableNotes = allNotes
        .where((note) => note.categoryId != widget.category.id)
        .toList();

    if (!mounted) return;

    if (availableNotes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr(context, 'no_notes_to_add')),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final selectedNotes = await showDialog<Set<int>>(
      context: context,
      builder: (context) => _AddNotesDialog(
        availableNotes: availableNotes,
        category: widget.category,
      ),
    );

    if (selectedNotes != null && selectedNotes.isNotEmpty) {
      for (final noteId in selectedNotes) {
        final note = allNotes.firstWhere((n) => n.id == noteId);
        final updatedNote = note.copyWith(categoryId: widget.category.id);
        await _storageService.updateNote(updatedNote);
      }
      _loadNotes();
      widget.onNotesChanged?.call();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${tr(context, 'notes_added_to_category')} ${selectedNotes.length}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
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

  String _getTranslatedCategoryName() {
    if (widget.category.translationKey != null &&
        widget.category.translationKey!.isNotEmpty) {
      return tr(context, widget.category.translationKey!);
    }
    return widget.category.name;
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = parseColor(widget.category.color);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getCategoryIcon(widget.category.icon),
              color: categoryColor,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                _getTranslatedCategoryName(),
                style: AppConstants.titleStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notes.isEmpty
          ? _buildEmptyState(categoryColor)
          : _buildNotesList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddNotesDialog,
        icon: const Icon(Icons.playlist_add),
        label: Text(tr(context, 'add_notes_to_category')),
        backgroundColor: categoryColor,
      ),
    );
  }

  Widget _buildEmptyState(Color categoryColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_outlined,
            size: 100,
            color: categoryColor.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            tr(context, 'no_notes_in_category'),
            style: AppConstants.titleStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tr(context, 'tap_to_add_notes'),
            style: AppConstants.bodyStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList() {
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.only(
          left: AppConstants.paddingMedium,
          right: AppConstants.paddingMedium,
          top: AppConstants.paddingMedium,
          bottom: 80,
        ),
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: NoteTile(
                  note: note,
                  isSelected: false,
                  isSelectionMode: false,
                  onFavoriteToggle: () => _toggleFavorite(note),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditNoteScreen(note: note),
                      ),
                    );
                    if (result == true) {
                      _loadNotes();
                      widget.onNotesChanged?.call();
                    }
                  },
                  onDelete: () => _showDeleteDialog(note),
                  showRemoveFromCategory: true,
                  onRemoveFromCategory: () => _removeFromCategory(note),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AddNotesDialog extends StatefulWidget {
  final List<Note> availableNotes;
  final Category category;

  const _AddNotesDialog({
    required this.availableNotes,
    required this.category,
  });

  @override
  State<_AddNotesDialog> createState() => _AddNotesDialogState();
}

class _AddNotesDialogState extends State<_AddNotesDialog> {
  final Set<int> _selectedNotes = {};

  String tr(BuildContext context, String key) {
    return AppLocalizations.of(context)!.translate(key);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(tr(context, 'select_notes_to_add')),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.availableNotes.length,
          itemBuilder: (context, index) {
            final note = widget.availableNotes[index];
            final isSelected = _selectedNotes.contains(note.id);

            return CheckboxListTile(
              title: Text(
                note.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                note.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedNotes.add(note.id!);
                  } else {
                    _selectedNotes.remove(note.id);
                  }
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(tr(context, 'cancel')),
        ),
        FilledButton(
          onPressed: _selectedNotes.isEmpty
              ? null
              : () => Navigator.pop(context, _selectedNotes),
          child: Text('${tr(context, 'add')} (${_selectedNotes.length})'),
        ),
      ],
    );
  }
}
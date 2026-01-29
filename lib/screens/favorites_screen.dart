import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/note_model.dart';
import '../services/local_storage_service.dart';
import '../utils/constants.dart';
import '../utils/app_localizations.dart';
import '../widgets/note_tile.dart';
import 'add_edit_note_screen.dart';

String tr(BuildContext context, String key) {
  return AppLocalizations.of(context)!.translate(key);
}

class FavoritesScreen extends StatefulWidget {
  final ValueNotifier<int> refreshNotifier;
  final VoidCallback onRefresh;

  const FavoritesScreen({
    super.key,
    required this.refreshNotifier,
    required this.onRefresh,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with AutomaticKeepAliveClientMixin {
  final LocalStorageService _storageService = LocalStorageService.instance;
  List<Note> _notes = [];
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
    widget.refreshNotifier.addListener(_onRefresh);
  }

  void _onRefresh() {
    if (mounted) {
      _loadNotes();
    }
  }

  @override
  void dispose() {
    widget.refreshNotifier.removeListener(_onRefresh);
    super.dispose();
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    final notes = await _storageService.getFavoriteNotes();
    setState(() {
      _notes = notes;
      _isLoading = false;
    });
  }

  Future<void> _deleteNote(int id) async {
    await _storageService.deleteNote(id);
    _loadNotes();
    widget.onRefresh();
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
    widget.onRefresh();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr(context, 'removed_from_favorites')),
          duration: const Duration(seconds: 1),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber),
            const SizedBox(width: 8),
            Text(
              tr(context, 'favorites'),
              style: AppConstants.titleStyle,
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notes.isEmpty
          ? _buildEmptyState()
          : _buildNotesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.star_outline,
            size: 100,
            color: Colors.amber,
          ),
          const SizedBox(height: 24),
          Text(
            tr(context, 'no_favorites'),
            style: AppConstants.titleStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tr(context, 'no_favorites_desc'),
            style: AppConstants.bodyStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
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
                      widget.onRefresh();
                    }
                  },
                  onDelete: () => _showDeleteDialog(note),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
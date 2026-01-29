import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/note_model.dart';
import '../services/local_storage_service.dart';
import '../utils/constants.dart';
import '../utils/app_localizations.dart';
import '../widgets/note_tile.dart';
import 'add_edit_note_screen.dart';
import 'settings_screen.dart';

String tr(BuildContext context, String key) {
  return AppLocalizations.of(context)!.translate(key);
}

class AllNotesScreen extends StatefulWidget {
  final ValueNotifier<int> refreshNotifier;
  final VoidCallback onRefresh;

  const AllNotesScreen({
    super.key,
    required this.refreshNotifier,
    required this.onRefresh,
  });

  @override
  State<AllNotesScreen> createState() => _AllNotesScreenState();
}

class _AllNotesScreenState extends State<AllNotesScreen> with AutomaticKeepAliveClientMixin {
  final LocalStorageService _storageService = LocalStorageService.instance;
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  bool _isLoading = true;
  bool _isSearching = false;
  bool _isSelectionMode = false;
  Set<int> _selectedNotes = {};
  final TextEditingController _searchController = TextEditingController();

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
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    final notes = await _storageService.getAllNotes();
    setState(() {
      _notes = notes;
      _filteredNotes = notes;
      _isLoading = false;
    });
  }

  void _searchNotes(String query) {
    if (query.isEmpty) {
      setState(() => _filteredNotes = _notes);
    } else {
      setState(() {
        _filteredNotes = _notes
            .where((note) =>
        note.title.toLowerCase().contains(query.toLowerCase()) ||
            note.content.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
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

  Future<void> _deleteMultiple() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr(context, 'delete_notes_title')),
        content: Text(
            '${tr(context, 'delete_message')}\n${_selectedNotes.length} ${tr(context, 'delete_notes_message')}'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
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
      for (int id in _selectedNotes) {
        await _storageService.deleteNote(id);
      }
      setState(() {
        _isSelectionMode = false;
        _selectedNotes.clear();
      });
      _loadNotes();
      widget.onRefresh();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr(context, 'notes_deleted')),
            duration: const Duration(seconds: 2),
          ),
        );
      }
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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: tr(context, 'search'),
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          onChanged: _searchNotes,
        )
            : Text(
          tr(context, 'my_notes'),
          style: AppConstants.titleStyle,
        ),
        actions: [
          if (_isSelectionMode) ...[
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '${_selectedNotes.length}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.select_all),
              tooltip: tr(context, 'tooltip_select_all'),
              onPressed: () {
                setState(() {
                  if (_selectedNotes.length == _filteredNotes.length) {
                    _selectedNotes.clear();
                  } else {
                    _selectedNotes = _filteredNotes.map((n) => n.id!).toSet();
                  }
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: tr(context, 'tooltip_delete'),
              onPressed: _selectedNotes.isEmpty ? null : _deleteMultiple,
            ),
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: tr(context, 'tooltip_cancel'),
              onPressed: () {
                setState(() {
                  _isSelectionMode = false;
                  _selectedNotes.clear();
                });
              },
            ),
          ] else ...[
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              tooltip: _isSearching ? tr(context, 'search_close') : tr(context, 'tooltip_search'),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                    _filteredNotes = _notes;
                  }
                });
              },
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              tooltip: tr(context, 'more'),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onSelected: (value) {
                if (value == 'settings') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                } else if (value == 'select_all') {
                  setState(() {
                    _isSelectionMode = true;
                    _selectedNotes = _filteredNotes.map((n) => n.id!).toSet();
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
                PopupMenuItem(
                  value: 'settings',
                  child: Row(
                    children: [
                      const Icon(Icons.settings),
                      const SizedBox(width: 12),
                      Text(tr(context, 'settings')),
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
          : _filteredNotes.isEmpty
          ? _buildEmptyState()
          : _buildNotesList(),
      floatingActionButton: _isSelectionMode
          ? null
          : FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditNoteScreen()),
          );
          if (result == true) {
            _loadNotes();
            widget.onRefresh();
          }
        },
        icon: const Icon(Icons.add),
        label: Text(tr(context, 'add_note')),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_outlined,
            size: 100,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            tr(context, 'no_notes'),
            style: AppConstants.titleStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tr(context, 'no_notes_desc'),
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
        itemCount: _filteredNotes.length,
        itemBuilder: (context, index) {
          final note = _filteredNotes[index];
          final isSelected = _selectedNotes.contains(note.id);

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: NoteTile(
                  note: note,
                  isSelected: isSelected,
                  isSelectionMode: _isSelectionMode,
                  onFavoriteToggle: () => _toggleFavorite(note),
                  onTap: () async {
                    if (_isSelectionMode) {
                      setState(() {
                        if (isSelected) {
                          _selectedNotes.remove(note.id);
                          if (_selectedNotes.isEmpty) {
                            _isSelectionMode = false;
                          }
                        } else {
                          _selectedNotes.add(note.id!);
                        }
                      });
                    } else {
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
                    }
                  },
                  onLongPress: () {
                    if (!_isSelectionMode) {
                      setState(() {
                        _isSelectionMode = true;
                        _selectedNotes.add(note.id!);
                      });
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
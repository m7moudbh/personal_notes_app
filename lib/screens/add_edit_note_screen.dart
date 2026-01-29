import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/local_storage_service.dart';
import '../utils/constants.dart';
import '../utils/app_localizations.dart';

String tr(BuildContext context, String key) {
  return AppLocalizations.of(context)!.translate(key);
}

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;
  final int? categoryId;

  const AddEditNoteScreen({super.key, this.note, this.categoryId});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final LocalStorageService _storageService = LocalStorageService.instance;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final note = Note(
          id: widget.note?.id,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          createdDate: widget.note?.createdDate ?? DateTime.now(),
          categoryId: widget.note?.categoryId ?? widget.categoryId,
          isFavorite: widget.note?.isFavorite ?? false,
        );

        if (widget.note == null) {
          await _storageService.createNote(note);
        } else {
          await _storageService.updateNote(note);
        }

        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${tr(context, 'error')}: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note == null ? tr(context, 'add_note') : tr(context, 'edit_note'),
          style: AppConstants.titleStyle,
        ),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveNote,
              tooltip: tr(context, 'save'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          children: [
            // حقل العنوان
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: tr(context, 'title'),
                hintText: tr(context, 'enter_title'),
                prefixIcon: Icon(
                  Icons.title,
                  color: Theme.of(context).colorScheme.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return tr(context, 'title_required');
                }
                if (value.trim().length < 1) {
                  return tr(context, 'title_min_length');
                }
                if (value.trim().length > AppConstants.maxTitleLength) {
                  return '${tr(context, 'title_max_length')} ${AppConstants.maxTitleLength}';
                }
                return null;
              },
              maxLength: AppConstants.maxTitleLength,
            ),
            const SizedBox(height: 16),

            // حقل المحتوى
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: tr(context, 'content'),
                hintText: tr(context, 'enter_content'),
                alignLabelWithHint: true,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Icon(
                    Icons.notes,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 15,
              maxLength: AppConstants.maxContentLength,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return tr(context, 'content_required');
                }
                if (value.trim().length < 1) {
                  return tr(context, 'content_min_length');
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
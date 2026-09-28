import 'package:flutter/material.dart';

import '../core/wine_notes_controller.dart';
import '../l10n/app_localizations.dart';
import '../models/wine.dart';

/// Окно редактирования личной заметки о вине.
Future<void> showWineNoteSheet(BuildContext context, Wine wine) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => _WineNoteSheet(wine: wine),
  );
}

class _WineNoteSheet extends StatefulWidget {
  final Wine wine;

  const _WineNoteSheet({required this.wine});

  @override
  State<_WineNoteSheet> createState() => _WineNoteSheetState();
}

class _WineNoteSheetState extends State<_WineNoteSheet> {
  late final WineNote? _existing = wineNotes.value[widget.wine.id];
  late int? _rating = _existing?.rating;
  late final _text = TextEditingController(text: _existing?.text);
  late final _place = TextEditingController(text: _existing?.place);

  @override
  void dispose() {
    _text.dispose();
    _place.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    await saveWineNote(
      widget.wine.id,
      WineNote(
        rating: _rating,
        text: _text.text.trim(),
        place: _place.text.trim(),
        updatedAt: DateTime.now(),
      ),
    );
    navigator.pop();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.noteSaved)));
  }

  Future<void> _delete() async {
    final navigator = Navigator.of(context);
    await deleteWineNote(widget.wine.id);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const titleStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w600);

    return Padding(
      // Поднимаемся над клавиатурой
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.wine.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.noteRating, style: titleStyle),
              const SizedBox(height: 4),
              StarRatingInput(
                value: _rating,
                onChanged: (v) => setState(() => _rating = v),
              ),
              const SizedBox(height: 16),
              Text(l10n.noteText, style: titleStyle),
              const SizedBox(height: 6),
              TextField(
                controller: _text,
                minLines: 3,
                maxLines: 6,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: l10n.noteTextHint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.notePlace, style: titleStyle),
              const SizedBox(height: 6),
              TextField(
                controller: _place,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: l10n.notePlaceHint,
                  prefixIcon: const Icon(Icons.storefront_outlined),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  if (_existing != null)
                    TextButton.icon(
                      onPressed: _delete,
                      icon: const Icon(Icons.delete_outline),
                      label: Text(l10n.noteDelete),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red[700],
                      ),
                    ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _save,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(140, 48),
                    ),
                    child: Text(l10n.noteSave),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Пять звёзд; повторное нажатие на выбранную звезду снимает оценку.
class StarRatingInput extends StatelessWidget {
  final int? value;
  final ValueChanged<int?> onChanged;

  const StarRatingInput({super.key, this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 1; i <= 5; i++)
          IconButton(
            tooltip: '$i',
            onPressed: () => onChanged(value == i ? null : i),
            icon: Icon(
              (value ?? 0) >= i
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              size: 36,
              color: (value ?? 0) >= i ? Colors.amber : Colors.grey,
            ),
          ),
      ],
    );
  }
}

/// Звёзды только для показа.
class StarRatingDisplay extends StatelessWidget {
  final int rating;
  final double size;

  const StarRatingDisplay({super.key, required this.rating, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          Icon(
            i <= rating ? Icons.star_rounded : Icons.star_outline_rounded,
            size: size,
            color: i <= rating ? Colors.amber : Colors.grey[400],
          ),
      ],
    );
  }
}

/// Блок «Мои заметки» в карточке вина.
class MyNoteSection extends StatelessWidget {
  final Wine wine;

  const MyNoteSection({super.key, required this.wine});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ValueListenableBuilder<Map<String, WineNote>>(
      valueListenable: wineNotes,
      builder: (context, notes, _) {
        final note = notes[wine.id];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.myNotes,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (note != null)
                  TextButton.icon(
                    onPressed: () => showWineNoteSheet(context, wine),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: Text(l10n.editNote),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (note == null)
              OutlinedButton.icon(
                onPressed: () => showWineNoteSheet(context, wine),
                icon: const Icon(Icons.edit_note),
                label: Text(l10n.addNote),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              )
            else
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => showWineNoteSheet(context, wine),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF0DFA8)),
                  ),
                  child: NoteSummary(note: note, maxLines: null),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Оценка, текст и место — для блока в карточке и превью в подвале.
class NoteSummary extends StatelessWidget {
  final WineNote note;
  final int? maxLines;

  const NoteSummary({super.key, required this.note, this.maxLines = 2});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (note.rating != null) StarRatingDisplay(rating: note.rating!),
        if (note.text.isNotEmpty) ...[
          if (note.rating != null) const SizedBox(height: 6),
          Text(
            note.text,
            maxLines: maxLines,
            overflow: maxLines == null ? null : TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
        ],
        if (note.place.isNotEmpty) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.storefront_outlined,
                size: 16,
                color: Colors.grey[700],
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  note.place,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

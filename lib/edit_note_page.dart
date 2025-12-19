import 'package:flutter/material.dart';
import 'models/note.dart';

class EditNotePage extends StatefulWidget {
  final Note? existing;
  const EditNotePage({super.key, this.existing});

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late List<TextEditingController> _paragraphControllers;
  final List<FocusNode> _focusNodes = [];



  @override
  void initState() {
    super.initState();
    _title = widget.existing?.title ?? '';
    _paragraphControllers = (widget.existing?.paragraphs ?? [''])
        .map((text) => TextEditingController(text: text))
        .toList();
    _initializeFocusNodes();
  }

  void _initializeFocusNodes() {
    _focusNodes.clear();
    for (int i = 0; i < _paragraphControllers.length; i++) {
      _focusNodes.add(FocusNode());
    }
  }

  void _addParagraph() {
    setState(() {
      _paragraphControllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes.last.requestFocus();
    });
  }

  void _removeParagraph(int index) {
    if (_paragraphControllers.length > 1) {
      setState(() {
        _paragraphControllers.removeAt(index);
        _focusNodes.removeAt(index).dispose();
      });
    }
  }

  void _saveNote() {
    final paragraphs = _paragraphControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (paragraphs.isEmpty) {
      paragraphs.add('');
    }

    final result = widget.existing == null
        ? Note(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: _title.trim().isEmpty ? 'Name_Your_note' : _title.trim(),
            paragraphs: paragraphs.isEmpty ? ['Your_text'] : paragraphs,
          )
        : widget.existing!.copyWith(
            title: _title.trim().isEmpty ? 'Name_Your_note' : _title.trim(),
            paragraphs: paragraphs.isEmpty ? ['Your_text'] : paragraphs,
          );

    Navigator.pop(context, result);
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD6B6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD6B6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF843A00)),
          onPressed: _goBack,
        ),
        title: Text(
          'Build a note',
          style: TextStyle(
            fontFamily: 'Caveat',
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF843A00),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Поле названия заметки
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFAD6D),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF8C582F),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: TextEditingController(text: _title),
                decoration: const InputDecoration(
                  hintText: 'Name of note',
                  hintStyle: TextStyle(
                    fontFamily: 'RobotoMono',
                    color: Color(0xFF843A00),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                style: TextStyle(
                  fontFamily: 'RobotoMono',
                  fontSize: 16,
                  color: const Color(0xFF843A00),
                ),
                onChanged: (value) => _title = value,
              ),
            ),

            const SizedBox(height: 20),

            // Список параграфов
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paragraphs:',
                    style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF843A00),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Expanded(
                    child: ListView.builder(
                      itemCount: _paragraphControllers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFAD6D),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF8C582F),
                                      width: 1,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _paragraphControllers[index],
                                    focusNode: _focusNodes[index],
                                    decoration: InputDecoration(
                                      hintText: index == 0
                                          ? '1st Paragraph'
                                          : 'Paragraph ${index + 1}',
                                      hintStyle: TextStyle(
                                        fontFamily: 'RobotoMono',
                                        color: const Color(0xFF843A00),
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.all(16),
                                    ),
                                    style: TextStyle(
                                      fontFamily: 'RobotoMono',
                                      fontSize: 14,
                                      color: const Color(0xFF843A00),
                                    ),
                                    minLines: 3,
                                    maxLines: 6,
                                    textInputAction: index ==
                                            _paragraphControllers.length - 1
                                        ? TextInputAction.done
                                        : TextInputAction.next,
                                    onSubmitted: (value) {
                                      if (index ==
                                          _paragraphControllers.length - 1) {
                                        _addParagraph();
                                      } else {
                                        _focusNodes[index + 1].requestFocus();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (_paragraphControllers.length > 1)
                                IconButton(
                                  onPressed: () => _removeParagraph(index),
                                  icon: const Icon(Icons.remove_circle,
                                      color: Color(0xFF843A00)),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  tooltip: 'Remove paragraph',
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Кнопка Add more Paragraphs
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ElevatedButton(
                      onPressed: _addParagraph,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFAD6D),
                        foregroundColor: const Color(0xFF843A00),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: Color(0xFF8C582F),
                            width: 1,
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Add more Paragraphs',
                        style: TextStyle(
                          fontFamily: 'RobotoMono',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Кнопки BACK и SAVE
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _goBack,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFAD6D),
                      foregroundColor: const Color(0xFF843A00),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: Color(0xFF8C582F),
                          width: 1,
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'BACK',
                      style: TextStyle(
                        fontFamily: 'RobotoMono',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveNote,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8627),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'SAVE',
                      style: TextStyle(
                        fontFamily: 'RobotoMono',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _paragraphControllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}

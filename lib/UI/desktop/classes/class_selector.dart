import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/Models/book_stack_view_state.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/books/switch_book.dart';
import 'package:buecherteam_2023_desktop/Util/transformer/grouper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassSelector extends StatelessWidget {
  const ClassSelector({super.key, required this.onSwitchBookView});

  final Function() onSwitchBookView;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ClassData>?>(
      future: Provider.of<BookStackViewState>(context, listen: false).getClasses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading classes'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No classes found'));
        } else {
          final classes = snapshot.data!;
          final groupedClasses = _groupClassesByLevel(classes);
          return Column(
            children: [
              SwitchBook(onSwitchBookView: onSwitchBookView),
              Expanded(
                child: ListView.builder(
                  itemCount: groupedClasses.keys.length,
                  itemBuilder: (context, index) {
                    final level = groupedClasses.keys.elementAt(index);
                    final classChars = groupedClasses[level]!;
                    return _buildClassRow(context,
                        level, classChars);
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Map<int, List<ClassData>> _groupClassesByLevel(List<ClassData> classes) {
    return groupClassesByLevel(classes);
  }

  Widget _buildClassRow(BuildContext context,
      int level, List<ClassData> classChars) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLevelIndicator(context, level),
          const SizedBox(width: 16.0),
        ...(classChars.toList()..sort((a, b) => a.classChar.compareTo(b.classChar)))
        .map((classData) =>
          _buildClassCharButton(context, classData))
        .toList(),

        ],
      ),
    );
  }

  Widget _buildLevelIndicator(BuildContext context, int level) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          level.toString(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }

  Widget _buildClassCharButton(
      BuildContext context, ClassData classData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Consumer<BookStackViewState>(
        builder:(context, state, _) => FilledButton.tonal(
          onPressed: () => state.selectClass(classData),
          style: state.selectedClass == classData
              ? ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.primary),
                  foregroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.onPrimary),
                )
              : null,
          child: Text(classData.classChar),
        ),
      ),
    );
  }
}

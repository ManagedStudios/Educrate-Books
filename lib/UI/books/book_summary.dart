import 'package:buecherteam_2023_desktop/Models/book_stack_view_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookSummary extends StatelessWidget {
  const BookSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookStateViewState>(
      builder: (context, provider, child) {
        if (provider.selectedClass == null) {
          return Container(); // Show nothing if no class is selected
        } else {
          return Card(
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Book Summary for ${provider.selectedClass!.getLabelText()}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.bookToAmount.length,
                      itemBuilder: (context, index) {
                        final book = provider.bookToAmount.keys.elementAt(index);
                        final amount = provider.bookToAmount.values.elementAt(index);
                        return Text('${book.name}: $amount');
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

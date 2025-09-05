import 'package:buecherteam_2023_desktop/Models/book_stack_view_state.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookSummary extends StatelessWidget {
  const BookSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookStackViewState>(
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
                    '${TextRes.bookStackSummary} ${provider.selectedClass!.getLabelText()}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.bookToAmount.length,
                      itemBuilder: (context, index) {
                        final book = provider.bookToAmount.keys.elementAt(index);
                        final amount = provider.bookToAmount.values.elementAt(index);
                        return RichText(
                          text: TextSpan(
                            // This is the default style that other TextSpans will inherit.
                            // It's good practice to start with the default style of your app's theme.
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              // 1. The book subject (bold)
                              TextSpan(
                                text: book.subject,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),

                              // A simple TextSpan for the space
                              const TextSpan(text: ' '),

                              // 2. The book name (smaller font size)
                              TextSpan(
                                text: book.name,
                                // Adjust the fontSize to what looks best for you.
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),

                              // 3. The rest of the text, which will use the default style
                              TextSpan(text: ': $amount'),
                            ],
                          ),
                        );
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

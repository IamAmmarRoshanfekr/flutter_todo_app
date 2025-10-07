import 'package:flutter/material.dart';
import 'package:mytodo/constants/quotes.dart';

class QuoteWidget extends StatelessWidget {
  const QuoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final randomQuote = getRandomQuote();
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(15, 15, 15, 0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Icon(Icons.format_quote)],
            ),
            Padding(
              padding: const EdgeInsets.all(11),
              child: Column(
                children: [
                  Text(
                    "${randomQuote["quote"]}",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${randomQuote["author"]}",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

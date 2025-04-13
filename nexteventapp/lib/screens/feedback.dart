import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Event'),
            DropdownButton<String>(
              isExpanded: true,
              hint: Text('Choose Event'),
              items: [],
              onChanged: null,
            ),
            const SizedBox(height: 10),
            const Text('Select SubEvent'),
            DropdownButton<String>(
              isExpanded: true,
              hint: Text('Choose SubEvent'),
              items: [],
              onChanged: null,
            ),
            const SizedBox(height: 20),
            const Text('Rating'),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              maxRating: 5,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (_) {},
            ),
            const SizedBox(height: 20),
            const Text('Comment'),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write your feedback...',
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: null,
                child: const Text('Submit Feedback'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

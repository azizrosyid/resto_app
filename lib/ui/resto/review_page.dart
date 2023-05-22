import 'package:flutter/material.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/data/model/restaurant_detail.dart';
import 'package:intl/intl.dart';

class ReviewRestaurantPage extends StatefulWidget {
  final String restaurantId;
  final List<CustomerReview> customerReviews;
  const ReviewRestaurantPage(
      {super.key, required this.customerReviews, required this.restaurantId});

  static const routeName = '/review_restaurant_page';

  @override
  State<ReviewRestaurantPage> createState() => _ReviewRestaurantPageState();
}

class _ReviewRestaurantPageState extends State<ReviewRestaurantPage> {
  String get _restaurantId => widget.restaurantId;
  List<CustomerReview> get _customerReviews => widget.customerReviews;
  ApiService apiService = ApiService();
  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _reviewController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Review Resto'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            const Text(
              'Reviews:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _customerReviews
                  .map(
                    (review) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(review.name),
                              Text(review.date),
                              Text(review.review),
                            ],
                          ),
                        ))),
                  )
                  .toList(),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: _reviewController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Review',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  if (_nameController.text.isEmpty ||
                      _reviewController.text.isEmpty) {
                    throw Exception('Name dan Review tidak boleh kosong');
                  }
                  apiService.postReview(_restaurantId, _nameController.text,
                      _reviewController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Berhasil menambahkan review'),
                    ),
                  );
                  setState(() {
                    _customerReviews.add(CustomerReview(
                        name: _nameController.text,
                        review: _reviewController.text,
                        date:
                            DateFormat("dd MMMM yyyy").format(DateTime.now())));
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Gagal menambahkan review'),
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ]),
        ));
  }
}

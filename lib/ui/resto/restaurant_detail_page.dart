import 'package:flutter/material.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/data/enum/fetch_state.dart';
import 'package:resto_app/data/model/restaurant_detail.dart';
import 'package:resto_app/widget/text_image.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;
  const RestaurantDetailPage({super.key, required this.restaurantId});

  static const routeName = '/restaurant_detail_page';

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  final apiService = ApiService();
  late FetchState _state = FetchState.pending;
  late RestaurantDetail _restaurant;

  @override
  void initState() {
    super.initState();
    _state = FetchState.pending;
    _fetchRestaurantDetail();
  }

  void _fetchRestaurantDetail() async {
    try {
      final result = await apiService.getRestaurantDetail(widget.restaurantId);
      if (!mounted) return;
      setState(() {
        _state = FetchState.success;
        _restaurant = RestaurantDetail.fromJson(result);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = FetchState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    if (_state == FetchState.success) {
      return AppBar(
        title: Text(_restaurant.name),
      );
    }
    return AppBar(
      title: const Text('Detail Resto'),
    );
  }

  Widget _buildBody() {
    if (_state == FetchState.pending) {
      return const TextImage(
        image: 'assets/images/empty-data.png',
        message: 'Data Kosong',
      );
    }
    if (_state == FetchState.error) {
      return TextImage(
        image: 'assets/images/no-internet.png',
        message: 'Koneksi Terputus',
        onPressed: _fetchRestaurantDetail,
      );
    }

    if (_state == FetchState.success) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://restaurant-api.dicoding.dev/images/large/${_restaurant.pictureId}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _restaurant.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Categories:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    children: _restaurant.categories
                        .map(
                          (category) => Chip(
                            label: Text(category.name),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Menus:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    'Foods:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _restaurant.menus.foods
                        .map((food) => Text(food.name))
                        .toList(),
                  ),
                  const Text(
                    'Drinks:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _restaurant.menus.drinks
                        .map((drink) => Text(drink.name))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Reviews:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _restaurant.customerReviews
                        .map(
                          (review) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(review.name),
                                const SizedBox(height: 4),
                                Text(review.review),
                                const SizedBox(height: 4),
                                Text(
                                  'Date: ${review.date}',
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox(
      height: 100,
      width: 125,
    );
  }
}

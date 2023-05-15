import 'package:flutter/material.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/data/enum/fetch_state.dart';
import 'package:resto_app/widget/card_restaurant.dart';
import 'package:resto_app/widget/text_image.dart';

import '../../data/model/restaurant.dart';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({Key? key}) : super(key: key);

  static const routeName = '/restaurant_list_page';

  @override
  RestaurantListPageState createState() => RestaurantListPageState();
}

class RestaurantListPageState extends State<RestaurantListPage> {
  late FetchState _state;
  late List<Restaurant> _restaurants;

  final apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _state = FetchState.pending;
    _restaurants = [];
    _fetchAllRestaurants();
  }

  void _fetchAllRestaurants() async {
    try {
      final result = await apiService.getRestaurantList();
      if (!mounted) return;
      setState(() {
        _state = FetchState.success;
        _restaurants = result.map((e) => Restaurant.fromJson(e)).toList();
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
    return AppBar(
      title: const Text('Cari Resto'),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case FetchState.success:
        return ListView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          itemCount: _restaurants.length,
          itemBuilder: (_, index) {
            Restaurant restaurant = _restaurants[index];
            return CardRestaurant(restaurant: restaurant);
          },
        );
      case FetchState.pending:
        return const TextImage(
          image: 'assets/images/empty-data.png',
          message: 'Data Kosong',
        );
      case FetchState.error:
        return TextImage(
          image: 'assets/images/no-internet.png',
          message: 'Koneksi Terputus',
          onPressed: _fetchAllRestaurants,
        );
      default:
        return const SizedBox();
    }
  }
}

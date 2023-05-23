import 'package:flutter/material.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/data/enum/fetch_state.dart';
import 'package:resto_app/widget/card_restaurant.dart';
import 'package:resto_app/widget/text_image.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

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
  late String _searchQuery;
  bool _isSearching = false;
  

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

  void _performSearch(String query) async {
    setState(() {
    _state = FetchState.pending;
    });

    try {
      final result = await apiService.searchRestaurant(query);
      if (!mounted) return;
      setState(() {
        _state = FetchState.success;
        _restaurants = result['restaurants']
            .map<Restaurant>((data) => Restaurant.fromJson(data))
            .toList();
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
      title: AnimSearchBar (
        rtl: true,
        helpText: "Cari Restoran",
        width: MediaQuery.of(context).size.width - 40,
        textController: TextEditingController(),
        onSuffixTap: () {
          setState(() {
            _isSearching = false;
            _fetchAllRestaurants();
          });
        },
        onSubmitted: (query) {
          setState(() {
            _isSearching = true;
          });
          _performSearch(query);
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_isSearching) {
      return _buildSearchResults();
    } else {
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
  
  Widget _buildSearchResults() {
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



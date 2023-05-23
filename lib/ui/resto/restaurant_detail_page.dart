import 'package:flutter/material.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/data/enum/fetch_state.dart';
import 'package:resto_app/data/model/restaurant_detail.dart';
import 'package:resto_app/ui/resto/review_page.dart';
import 'package:resto_app/widget/text_image.dart';

class Favorite {
  static final Favorite _instance = Favorite._internal();

  factory Favorite() {
    return _instance;
  }

  Favorite._internal();

  final Set<String> _favorites = <String>{};
  Set<String> get favorites => _favorites;

  void addFavorite(String id) {
    _favorites.add(id);
  }

  void removeFavorite(String id) {
    _favorites.remove(id);
  }

  bool isFavorite(String id) {
    return _favorites.contains(id);
  }

  List<String> getFavorite() {
    return _favorites.toList();
  }
}
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
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _state = FetchState.pending;
    _fetchRestaurantDetail();
  }

  void _fetchRestaurantDetail() async {
    final isFavorite = Favorite().isFavorite(widget.restaurantId);
    try {
      final result = await apiService.getRestaurantDetail(widget.restaurantId);
      if (!mounted) return;
      setState(() {
        _state = FetchState.success;
        _restaurant = RestaurantDetail.fromJson(result);
        _isFavorite = isFavorite;
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
        actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _isFavorite = !_isFavorite;
              if (_isFavorite) {
                Favorite().addFavorite(_restaurant.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Berhasil menambahkan ke favorite'),
                  ),
                );
              } else {
                Favorite().removeFavorite(_restaurant.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Berhasil menghapus dari favorite'),
                  ),
                );
              }
            });
          },
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
        ),
      ],
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReviewRestaurantPage(
                                    restaurantId: _restaurant.id,
                                    customerReviews:
                                        _restaurant.customerReviews,
                                  )));
                    },
                    child: Text('Reviews', style: TextStyle(fontSize: 16)),
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

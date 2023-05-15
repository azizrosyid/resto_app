class RestaurantDetail {
  String id;
  String name;
  String description;
  String city;
  String address;
  String pictureId;
  List<Category> categories;
  Menus menus;
  double rating;
  List<CustomerReview> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    var categoryList = json['categories'] as List;
    var foodList = json['menus']['foods'] as List;
    var drinkList = json['menus']['drinks'] as List;
    var reviewList = json['customerReviews'] as List;

    return RestaurantDetail(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      city: json['city'],
      address: json['address'],
      pictureId: json['pictureId'],
      categories:
          categoryList.map((category) => Category.fromJson(category)).toList(),
      menus: Menus(
        foods: foodList.map((food) => Menu.fromJson(food)).toList(),
        drinks: drinkList.map((drink) => Menu.fromJson(drink)).toList(),
      ),
      rating: json['rating'].toDouble(),
      customerReviews:
          reviewList.map((review) => CustomerReview.fromJson(review)).toList(),
    );
  }
}

class Category {
  String name;

  Category({required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json['name']);
  }
}

class Menu {
  String name;

  Menu({required this.name});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(name: json['name']);
  }
}

class Menus {
  List<Menu> foods;
  List<Menu> drinks;

  Menus({required this.foods, required this.drinks});
}

class CustomerReview {
  String name;
  String review;
  String date;

  CustomerReview(
      {required this.name, required this.review, required this.date});

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'],
      review: json['review'],
      date: json['date'],
    );
  }
}

import 'dart:convert';

class Category {
  final String? name;

  Category({this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json['name'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}

class MenuItem {
  final String? name;

  MenuItem({this.name});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(name: json['name'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}

class Menus {
  final List<MenuItem>? foods;
  final List<MenuItem>? drinks;

  Menus({this.foods, this.drinks});

  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      foods:
          (json['foods'] as List<dynamic>?)
              ?.map((item) => MenuItem.fromJson(item as Map<String, dynamic>))
              .toList(),
      drinks:
          (json['drinks'] as List<dynamic>?)
              ?.map((item) => MenuItem.fromJson(item as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foods': foods?.map((item) => item.toJson()).toList(),
      'drinks': drinks?.map((item) => item.toJson()).toList(),
    };
  }
}

class CustomerReview {
  final String? name;
  final String? review;
  final String? date;

  CustomerReview({this.name, this.review, this.date});

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'] as String?,
      review: json['review'] as String?,
      date: json['date'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'review': review, 'date': date};
  }
}

class Restaurant {
  final String? id;
  final String? name;
  final String? description;
  final String? pictureId;
  final String? city;
  final String? address;
  final double? rating;
  final List<Category>? categories;
  final Menus? menus;
  final List<CustomerReview>? customerReviews;

  Restaurant({
    this.id,
    this.name,
    this.description,
    this.pictureId,
    this.city,
    this.address,
    this.rating,
    this.categories,
    this.menus,
    this.customerReviews,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      pictureId: json['pictureId'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      categories:
          json['categories'] != null
              ? (json['categories'] is String
                  ? (jsonDecode(json['categories'] as String) as List<dynamic>?)
                      ?.map(
                        (item) =>
                            Category.fromJson(item as Map<String, dynamic>),
                      )
                      .toList()
                  : (json['categories'] as List<dynamic>?)
                      ?.map(
                        (item) =>
                            Category.fromJson(item as Map<String, dynamic>),
                      )
                      .toList())
              : null,
      menus:
          json['menus'] != null
              ? (json['menus'] is String
                  ? Menus.fromJson(
                    jsonDecode(json['menus'] as String) as Map<String, dynamic>,
                  )
                  : Menus.fromJson(json['menus'] as Map<String, dynamic>))
              : null,
      customerReviews:
          json['customerReviews'] != null
              ? (json['customerReviews'] is String
                  ? (jsonDecode(json['customerReviews'] as String)
                          as List<dynamic>?)
                      ?.map(
                        (item) => CustomerReview.fromJson(
                          item as Map<String, dynamic>,
                        ),
                      )
                      .toList()
                  : (json['customerReviews'] as List<dynamic>?)
                      ?.map(
                        (item) => CustomerReview.fromJson(
                          item as Map<String, dynamic>,
                        ),
                      )
                      .toList())
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pictureId': pictureId,
      'city': city,
      'address': address,
      'rating': rating,
      'categories': jsonEncode(
        categories?.map((item) => item.toJson()).toList(),
      ),
      'menus': jsonEncode(menus?.toJson()),
      'customerReviews': jsonEncode(
        customerReviews?.map((item) => item.toJson()).toList(),
      ),
    };
  }
}

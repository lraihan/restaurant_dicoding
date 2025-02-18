class Category {
  final String? name;

  Category({this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class MenuItem {
  final String? name;

  MenuItem({this.name});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class Menus {
  final List<MenuItem>? foods;
  final List<MenuItem>? drinks;

  Menus({this.foods, this.drinks});

  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      foods: (json['foods'] as List?)?.map((i) => MenuItem.fromJson(i)).toList(),
      drinks: (json['drinks'] as List?)?.map((i) => MenuItem.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foods': foods?.map((i) => i.toJson()).toList(),
      'drinks': drinks?.map((i) => i.toJson()).toList(),
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
      name: json['name'],
      review: json['review'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'review': review,
      'date': date,
    };
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
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureId: json['pictureId'],
      city: json['city'],
      address: json['address'],
      rating: (json['rating'] as num?)?.toDouble(),
      categories: (json['categories'] as List?)?.map((i) => Category.fromJson(i)).toList(),
      menus: json['menus'] != null ? Menus.fromJson(json['menus']) : null,
      customerReviews: (json['customerReviews'] as List?)?.map((i) => CustomerReview.fromJson(i)).toList(),
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
      'categories': categories?.map((i) => i.toJson()).toList(),
      'menus': menus?.toJson(),
      'customerReviews': customerReviews?.map((i) => i.toJson()).toList(),
    };
  }
}

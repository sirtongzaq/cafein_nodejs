// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ffi';

class Store {
  final String id;
  final String string_name;
  final String rating;
  final String count_rating;
  final String price;
  final String open_dialy;
  final String address;
  final String contact;
  final String facebook;
  final String type;
  final String likes;
  final int views;
  Store({
    required this.id,
    required this.string_name,
    required this.rating,
    required this.count_rating,
    required this.price,
    required this.open_dialy,
    required this.address,
    required this.contact,
    required this.facebook,
    required this.type,
    required this.likes,
    required this.views,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'string_name': string_name,
      'rating': rating,
      'count_rating': count_rating,
      'price': price,
      'open_dialy': open_dialy,
      'address': address,
      'contact': contact,
      'facebook': facebook,
      'type': type,
      'likes': likes,
      'views': views,
    };
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      id: map['id'] as String,
      string_name: map['string_name'] as String,
      rating: map['rating'] as String,
      count_rating: map['count_rating'] as String,
      price: map['price'] as String,
      open_dialy: map['open_dialy'] as String,
      address: map['address'] as String,
      contact: map['contact'] as String,
      facebook: map['facebook'] as String,
      type: map['type'] as String,
      likes: map['likes'] as String,
      views: map['views'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Store.fromJson(String source) => Store.fromMap(json.decode(source) as Map<String, dynamic>);
}

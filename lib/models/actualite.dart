import 'package:kondjigbale/models/actu_response.dart';

class Actualite {
  int? id;
  String? keyBlog;
  String? titre;
  String? description;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? image;
  String? shareLink;
  List<Categories>? categories;

  Actualite(
      {this.id,
      this.keyBlog,
      this.titre,
      this.description,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.image,
      this.shareLink,
      this.categories});

  Actualite.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    keyBlog = json['key_blog'];
    titre = json['titre'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    shareLink = json['share_link'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['key_blog'] = keyBlog;
    data['titre'] = titre;
    data['description'] = description;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image'] = image;
    data['share_link'] = shareLink;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

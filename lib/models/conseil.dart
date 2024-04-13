import 'package:kondjigbale/models/expert.dart';

class Conseil {
  int? id;
  String? keyConseil;
  String? titre;
  String? description;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? coverImage;
  String? media;
  int? typeMedia;
  String? shareLink;
  int? allLike;
  int? allSave;
  int? isLike;
  int? isSave;
  int? shares;
  Expert? expert;
  List<Categories>? categories;
  bool? isSaving;
  bool? isShare;
  bool? isLiking;

  Conseil({
    this.id,
    this.keyConseil,
    this.titre,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.coverImage,
    this.media,
    this.typeMedia,
    this.shareLink,
    this.allLike,
    this.allSave,
    this.isLike,
    this.isSave,
    this.shares,
    this.expert,
    this.categories,
    this.isLiking = false,
    this.isShare = false,
    this.isSaving = false,
  });

  Conseil.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    keyConseil = json['key_conseil'];
    titre = json['titre'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    coverImage = json['cover_image'];
    media = json['media'];
    typeMedia = json['type_media'];
    shareLink = json['share_link'];
    allLike = json['all_like'];
    allSave = json['all_save'];
    isLike = json['is_like'];
    isSave = json['is_save'];
    shares = json['shares'];
    expert =
        json['expert'] != null ? Expert.fromJson(json['expert']) : null;
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
    data['key_conseil'] = keyConseil;
    data['titre'] = titre;
    data['description'] = description;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['cover_image'] = coverImage;
    data['media'] = media;
    data['type_media'] = typeMedia;
    data['share_link'] = shareLink;
    data['all_like'] = allLike;
    data['all_save'] = allSave;
    data['is_like'] = isLike;
    data['is_save'] = isSave;
    data['shares'] = shares;
    if (expert != null) {
      data['expert'] = expert!.toJson();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String? keyCategorie;
  String? nom;
  String? image;

  Categories({this.keyCategorie, this.nom, this.image});

  Categories.fromJson(Map<String, dynamic> json) {
    keyCategorie = json['key_categorie'];
    nom = json['nom'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key_categorie'] = keyCategorie;
    data['nom'] = nom;
    data['image'] = image;
    return data;
  }
}

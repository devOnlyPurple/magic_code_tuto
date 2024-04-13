class OnboardData {
  final int id;
  final String description;
  final String image;
  final String title;

  OnboardData({
    required this.id,
    required this.image,
    required this.description,
    required this.title,
  });

  factory OnboardData.fromJson(Map<String, dynamic> json) {
    return OnboardData(
      id: json['id'],
      image: json['image'],
      description: json['description'],
      title: json['title'],
    );
  }
}

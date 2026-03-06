class MenuItem {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String image; // URL or asset path

  const MenuItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
  });
}

import 'package:duration/duration.dart';

enum RecipeType {
  food,drink
}

class Recipe {
  final String id;
  final RecipeType type;
  final String name;
  final Duration duration;
  final List<String> ingredients;
  final List<String> preparation;
  final String imageURL;

  const Recipe({
    this.id,
    this.type,
    this.duration,
    this.imageURL,
    this.ingredients,
    this.name,
    this.preparation,
  });
  String get getDurationString => prettyDuration(this.duration);
}
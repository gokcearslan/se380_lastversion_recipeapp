class Recipe{

  final String name;
  final String images;

  Recipe({this.name,this.images});

  factory Recipe.fromJson(dynamic json){
    return Recipe(
      name:json['name'] as String,
      images:json['images'][0]['hostedLargeUrl'] as String

    );
  }

  static List<Recipe> recipesFromSnapshot(List snapshot)
  {
    return snapshot.map(
            (data) {
      return Recipe.fromJson(data);
    }
    ).toList();

  }
}
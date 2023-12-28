import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:se380_lastversion_recipeapp/services/fire_recipe.dart';
import 'package:se380_lastversion_recipeapp/services/recipe_model.dart';
import 'package:se380_lastversion_recipeapp/services/recipe_provider.dart';

class CreateRecipePage extends StatefulWidget {
  @override
  _CreateRecipePageState createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final Color primaryColor = Colors.blue;
  final Color redP = Colors.red;

  final TextEditingController _recipeNameController = TextEditingController();
  List<TextEditingController> _ingredientControllers = [TextEditingController()];
  String? _selectedCategory;
  bool _isCategorySelected = false;

  final Map<String, String> _categoryImages = {
    'Breakfast': 'https://static01.nyt.com/images/2023/04/23/multimedia/23WELL-HEALTHY-BREAKFAST9-lgwc/23WELL-HEALTHY-BREAKFAST9-lgwc-videoSixteenByNine3000.jpg',
    'Soup': 'https://assets.epicurious.com/photos/64553451cf62528d44c9cc63/4:3/w_5123,h_3842,c_limit/CelerySoup_RECIPE_050323_53866.jpg',
    'Main Course':'https://st2.depositphotos.com/3210553/9823/i/450/depositphotos_98232150-stock-photo-pan-fried-salmon-with-tender.jpg',
    'Drink':'https://www.shutterstock.com/image-photo/lemonade-mojito-cocktail-lemon-mint-260nw-662695249.jpg',
    'Salad':'https://hips.hearstapps.com/hmg-prod/images/greek-salad-index-642f292397bbf.jpg?crop=0.6666666666666667xw:1xh;center,top&resize=1200:*',
    'Dessert':'https://realfood.tesco.com/media/images/RFO-1400x919-classic-chocolate-mousse-69ef9c9c-5bfb-4750-80e1-31aafbd80821-0-1400x919.jpg',
    'Fast-Food':'https://media.istockphoto.com/id/931308812/tr/foto%C4%9Fraf/amerikan-g%C4%B1da-se%C3%A7imi.jpg?s=612x612&w=0&k=20&c=Aeknfji2foAIzLNuonhRWEHW2A9zBLQgf8JNE0Lqj5g=',
    'Mexican':'https://www.thedailymeal.com/img/gallery/mexican-food-can-be-traced-all-the-way-back-to-7000-bc/intro-1674486308.jpg',
    'Chinese':'https://t3.ftcdn.net/jpg/01/15/26/28/360_F_115262838_Qdfwviyw9ATjw0TNnky95RjvKoQXprj5.jpg',
    'Others':'https://www.englishclub.com/images/vocabulary/food/good-foods.jpg',
  };


  InputDecoration textFieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      alignLabelWithHint: true,
      labelStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
      filled: true, // Add fill color
      fillColor: Colors.white.withOpacity(0.9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(color: primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(color: redP, width: 2.0),
      ),
    );
  }
  void _addIngredientField() {
    setState(() {
      _ingredientControllers.add(TextEditingController());
    });
  }

  void _saveRecipe() async {
    List<String> ingredients = _ingredientControllers.map((controller) => controller.text).where((ingredient) => ingredient.isNotEmpty).toList();

    if (_recipeNameController.text.isNotEmpty && ingredients.isNotEmpty) {
      Recipe newRecipe = Recipe(
        name: _recipeNameController.text,
        ingredientIds: ingredients,
        category: _selectedCategory!,
        id: '',
      );

      await FirebaseService().saveRecipe(newRecipe);

      _resetForm();
    } else {
      // Handle empty fields (e.g., show an alert)
    }
  }

  void _resetForm() {
    _recipeNameController.clear();
    _ingredientControllers.forEach((controller) => controller.clear());
    _ingredientControllers = [TextEditingController()];
    _selectedCategory = null;
    _isCategorySelected = false;
    setState(() {});
  }

  Widget _buildCategoryList() {
    return _isCategorySelected ? SizedBox() : ListView.builder(
      shrinkWrap: true,
      itemCount: _categoryImages.length,
      itemBuilder: (context, index) {
        String category = _categoryImages.keys.elementAt(index);
        String imageUrl = _categoryImages[category]!;

        return Container(
          margin: EdgeInsets.symmetric(vertical: 4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
            ),
          ),
          child: ListTile(
            title: Text(category, style: TextStyle(color: Colors.white)),
            onTap: () {
              setState(() {
                _selectedCategory = category;
                _isCategorySelected = true;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildRecipeForm() {
    return _isCategorySelected ? Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _recipeNameController,
            decoration: textFieldDecoration('Recipe Name'),
          ),
          SizedBox(height: 16.0),
          Text('Ingredients:', style: TextStyle(color: primaryColor)),
          ..._ingredientControllers.map((controller) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: controller,
              decoration: textFieldDecoration('Ingredient'),
            ),
          )),
          TextButton.icon(
            onPressed: _addIngredientField,
            icon: Icon(Icons.add, color: primaryColor),
            label: Text('Add Ingredient', style: TextStyle(color: primaryColor)),
          ),
        ],
      ),
    ) : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Recipe'),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCategoryList(),
            SizedBox(height: 20), // Spacing
            _buildRecipeForm(),
            SizedBox(height: 20), // Spacing
            // Optionally add more widgets for aesthetic enhancement
          ],
        ),
      ),
      floatingActionButton: _isCategorySelected ? FloatingActionButton(
        onPressed: _saveRecipe,
        child: Icon(Icons.save),
        backgroundColor: redP,
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  @override
  void dispose() {
    _recipeNameController.dispose();
    _ingredientControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }
}

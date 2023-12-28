import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:se380_lastversion_recipeapp/FilteredRecipe.dart';

import 'color.dart';

class CategorySelectionScreen extends StatefulWidget {
  @override
  _CategorySelectionScreenState createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
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

  List<String> allCategories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('recipes').get();
      final Set<String> categories = {};
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('category')) {
          categories.add(data['category']);
        }
      }
      setState(() {
        allCategories = categories.toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Category', style: TextStyle(color: Colors.white)),
        backgroundColor: Navy,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchCategories,
        child: AnimationLimiter(
          child: GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3 / 2,
            ),
            itemCount: allCategories.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 375),
                columnCount: 2,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: CategoryCard(
                      category: allCategories[index],
                      categoryImages: _categoryImages,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String category;
  final Map<String, String> categoryImages;

  CategoryCard({required this.category, required this.categoryImages});

  @override
  Widget build(BuildContext context) {
    String imageUrl = categoryImages[category] ?? 'assets/default_placeholder.png'; // Fallback to a default image

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => _navigateToCategoryPage(context, category),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Text(
              category,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCategoryPage(BuildContext context, String category) {
    recipesAccordingCategory(context, category);
  }
}

void recipesAccordingCategory(BuildContext context, String category) async {
  try {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance
        .collection('recipes')
        .where('category', isEqualTo: category)
        .get();

    List<String> filteredRecipeNames = querySnapshot.docs
        .map((doc) => doc['name'] as String)
        .toList(); // Assuming 'name' is a field in each document.

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilteredRecipesScreen(
          filteredRecipeNames: filteredRecipeNames,
        ),
      ),
    );
  } catch (e) {
    print('Error fetching and filtering recipes: $e');
  }}

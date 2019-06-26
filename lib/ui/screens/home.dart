import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/model/recipe.dart';
import 'package:recipes_app/ui/recipeCard.dart';
import 'package:recipes_app/utils/store.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Recipe> recipes = getRecipes();
  List<String> userFavorites = getFavoritesIDs();

  // favorite or unfavorite recipe
  void _handleFavoriteListChanged(String recipeID) {
    setState(() {
      if (userFavorites.contains(recipeID)) {
        userFavorites.remove(recipeID);
      } else {
        userFavorites.add(recipeID);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Padding _buildRecipes(List<Recipe> recipeList) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: recipeList.length,
                itemBuilder: (BuildContext context, int index) {
                  return RecipeCard(
                  recipe: recipeList[index],
                  inFavorites: userFavorites.contains(recipeList[index].id),
                  onFavoriteButtonPressed: _handleFavoriteListChanged,
                  );
                },
              ),
            )
          ],
        ),
      );
    }

    double _iconSize = 20.0;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: Colors.deepOrange,
            elevation: 2.0,
            bottom: TabBar(
              labelColor: Colors.white,
              tabs: [
                Tab(icon: Icon(Icons.restaurant, size: _iconSize)),
                Tab(icon: Icon(Icons.local_drink, size: _iconSize)),
                Tab(icon: Icon(Icons.favorite, size: _iconSize)),
                Tab(icon: Icon(Icons.settings, size: _iconSize))
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(5.0),
          child: TabBarView(
            children: [
              // display recipe type food
              _buildRecipes(recipes
                  .where((recipe) => recipe.type == RecipeType.food)
                  .toList()),

              // display recipes type drink
              _buildRecipes(recipes
                  .where((recipe) => recipe.type == RecipeType.drink)
                  .toList()),

              // display recipes
              _buildRecipes(recipes
                  .where((recipe) => userFavorites.contains(recipe.id))
                  .toList()),
              Center(child: Icon(Icons.settings)),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/model/recipe.dart';
import 'package:recipes_app/model/state.dart';
import 'package:recipes_app/state_widget.dart';
import 'package:recipes_app/ui/recipeCard.dart';
import 'package:recipes_app/ui/screens/login.dart';
import 'package:recipes_app/utils/store.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  StateModel appState;
  List<Recipe> recipes = getRecipes();
  List<String> userFavorites = getFavoritesIDs();

  DefaultTabController _buildTabView({Widget body}) {
    double _iconSize = 20.0;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            elevation: 2.0,
            bottom: TabBar(
              labelColor: Colors.black,
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
          child: body,
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (appState.isLoading) {

      // app is loading
      return _buildTabView(
        body: _buildLoadingIndicator(),
      );
    } else if (!appState.isLoading && appState.user == null) {
      // app is not loading and user has not logged in
      return new LoginScreen();
    } else {

      // app is not loading and user is logged in
      return _buildTabView(
        body: _buildTabsContent(),
      );
    }
  }

  Center _buildLoadingIndicator() {
    return Center(
      child: new CircularProgressIndicator(),
    );
  }

  TabBarView _buildTabsContent() {
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

    return TabBarView(
      children: [
        // display recipe type food
        _buildRecipes(
            recipes.where((recipe) => recipe.type == RecipeType.food).toList()),

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
    );
  }

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
    appState = StateWidget.of(context).state;
    return _buildContent();
  }
}

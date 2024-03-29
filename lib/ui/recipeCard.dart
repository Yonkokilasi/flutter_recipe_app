import 'package:flutter/material.dart';
import 'package:recipes_app/model/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool inFavorites;
  final Function onFavoriteButtonPressed;

  RecipeCard(
      {@required this.recipe,
      @required this.inFavorites,
      @required this.onFavoriteButtonPressed});

  @override
  Widget build(BuildContext context) {
    RawMaterialButton _buildFavoriteButton() {
      return RawMaterialButton(
        constraints: const BoxConstraints(minWidth: 40.0, minHeight: 40.0),
        onPressed: () => onFavoriteButtonPressed(recipe.id),
        child:Icon(
          inFavorites == true ? Icons.favorite : Icons.favorite_border,color: Theme.of(context).iconTheme.color,),
        fillColor: Theme.of(context).buttonColor,
        shape: CircleBorder(),
      );
    }

    Padding _buildTitleSection() {
      return Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(recipe.name,style: Theme.of(context).textTheme.title,),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Icon(Icons.timer, size: 20.0),
                SizedBox(width: 5.0),
                Text(recipe.getDurationString,style: Theme.of(context).textTheme.caption,),
              ],
            )
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => print('Boom'),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Card(
          color:  const Color(0xFFF5F5F5),
          elevation: 5.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 16.0 / 9.0,
                    child: Image.network(
                      recipe.imageURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    child: _buildFavoriteButton(),
                    top: 2.0,
                    right: 2.0,
                  )
                ],
              ),
              _buildTitleSection(),
            ],
          ),
        ),
      ),
    );
  }
}

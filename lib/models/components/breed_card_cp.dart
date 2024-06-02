import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mimbo_caisse/models/cat_breed_model.dart';

/// A widget that displays a card containing information about a cat breed.
/// 
/// The card shows an image of the breed (if available), the breed's name,
/// origin, temperament, life span, weight, and friendliness scores.
class BreedCard extends StatelessWidget {
  /// The cat breed to be displayed in the card.
  final CatBreed breed;

  /// Creates a BreedCard widget.
  /// 
  /// The [breed] parameter is required and must not be null.
  const BreedCard({Key? key, required this.breed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: breed.referenceImageId != null
            ? CachedNetworkImage(
                imageUrl: 'https://cdn2.thecatapi.com/images/${breed.referenceImageId}.jpg',
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
            : Icon(Icons.image, size: 50),
        title: Text(breed.name ?? 'Unknown'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (breed.origin != null) Text('Origin: ${breed.origin}'),
            if (breed.temperament != null) Text('Temperament: ${breed.temperament}'),
            if (breed.lifeSpan != null) Text('Life Span: ${breed.lifeSpan} years'),
            if (breed.weight != null) Text('Weight: ${breed.weight?.metric} kg'),
            if (breed.childFriendly != null) Text('Child Friendly: ${breed.childFriendly}'),
            if (breed.dogFriendly != null) Text('Dog Friendly: ${breed.dogFriendly}'),
            if (breed.strangerFriendly != null) Text('Stranger Friendly: ${breed.strangerFriendly}'),
          ],
        ),
      ),
    );
  }
}

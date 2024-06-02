
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mimbo_caisse/models/cat_breed_model.dart';
import 'package:mimbo_caisse/models/components/breed_card_cp.dart';
class CatBreedsScreen extends StatefulWidget {
  @override
  _CatBreedsScreenState createState() => _CatBreedsScreenState();
}

class _CatBreedsScreenState extends State<CatBreedsScreen> {
  String _timeString = "";
  List<CatBreed> _catBreeds = [];
   
  List<CatBreed> _filteredCatBreeds = [];

  TextEditingController childFriendlyController = TextEditingController();
  TextEditingController strangerFriendlyController = TextEditingController();
  TextEditingController dogFriendlyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    _fetchCatBreeds();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

 Future<void> _fetchCatBreeds() async {
    final response = await http.get(Uri.parse('https://api.thecatapi.com/v1/breeds'));
    if (response.statusCode == 200) {
      setState(() {
        _catBreeds = (json.decode(response.body) as List)
            .map((data) => CatBreed.fromJson(data))
            .toList();
        _filteredCatBreeds = _catBreeds;
      });
    } else {
      throw Exception('Failed to load cat breeds');
    }
  }

  

  void _filterBreeds() {
    int childFriendly = int.tryParse(childFriendlyController.text) ?? 0;
    int strangerFriendly = int.tryParse(strangerFriendlyController.text) ?? 0;
    int dogFriendly = int.tryParse(dogFriendlyController.text) ?? 0;

    setState(() {
      _filteredCatBreeds = _catBreeds.where((breed) {
        return (breed.childFriendly ?? 0) >= childFriendly &&
               (breed.strangerFriendly ?? 0) >= strangerFriendly &&
               (breed.dogFriendly ?? 0) >= dogFriendly;
      }).toList();
    });
  }


  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cat Breeds App'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_timeString, style: TextStyle(fontSize: 18)),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                TextField(
                  controller: childFriendlyController,
                  decoration: InputDecoration(
                    labelText: 'Child Friendly Score',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: strangerFriendlyController,
                  decoration: InputDecoration(
                    labelText: 'Stranger Friendly Score',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: dogFriendlyController,
                  decoration: InputDecoration(
                    labelText: 'Dog Friendly Score',
                  ),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: _filterBreeds,
                  child: Text('Filter'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredCatBreeds.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredCatBreeds.length,
                    itemBuilder: (context, index) {
                      final breed = _filteredCatBreeds[index];
                      return BreedCard(breed: breed);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
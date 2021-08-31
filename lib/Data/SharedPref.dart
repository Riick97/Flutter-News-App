import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  Future<bool?> getFirstStart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? firstStart = prefs.getBool('firtStart');
    return firstStart;
  }

  Future<bool?> setFirstStart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firtStart', false);
  }

  Future<List<String>> getLiked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? likedList = prefs.getStringList('liked');
    return likedList!;
  }

  Future<bool> setLiked(List<String> likedList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('liked', likedList);
    return true;
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? darkMode = prefs.getBool('darkMode');
    return darkMode!;
  }

  Future<void> setTheme(bool darkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', darkMode);
  }

  Future<bool> getCardView() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? cardView = prefs.getBool('cardView');
    return cardView!;
  }

  Future<void> setCardView(bool cardView) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('cardView', cardView);
  }
}

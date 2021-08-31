import 'dart:async';

class ThemeBloc {
  final _darkMode = StreamController<bool>.broadcast();

  Stream<bool> get darkMode => _darkMode.stream;

  ThemeBloc._privateConstructor();

  static final ThemeBloc _instance = ThemeBloc._privateConstructor();

  setDarkMode(bool darkMode) async {
    _darkMode.sink.add(darkMode);
  }

  factory ThemeBloc() {
    return _instance;
  }

  dispose() {
    _darkMode.close();
  }
}

class CardViewBloc {
  final _cardView = StreamController<bool>.broadcast();

  Stream<bool> get cardView => _cardView.stream;

  CardViewBloc._privateConstructor();

  static final CardViewBloc _instance = CardViewBloc._privateConstructor();

  factory CardViewBloc(){
    return _instance;
  }

  setCardView(bool cardView) async {
    _cardView.sink.add(cardView);
  }

  dispose() {
    _cardView.close();
  }
}

class SortBloc {
  final _sort = StreamController<String>.broadcast();

  Stream<String> get sortStream => _sort.stream;

  SortBloc._privateConstructor();

  static final SortBloc _instance = SortBloc._privateConstructor();

  factory SortBloc() {
    return _instance;
  }

  setSort(String cardView) async {
    _sort.sink.add(cardView);
  }

  dispose() {
    _sort.close();
  }
}

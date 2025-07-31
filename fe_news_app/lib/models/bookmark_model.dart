import 'package:flutter/material.dart';

class BookmarkModel extends ChangeNotifier {
  final Set<String> _links = {};

  bool isBookmarked(String link) => _links.contains(link);

  void setInitial(Set<String> initial) {
    _links.clear();
    _links.addAll(initial);
    notifyListeners();
  }

  void add(String link) {
    _links.add(link);
    notifyListeners();
  }

  void remove(String link) {
    _links.remove(link);
    notifyListeners();
  }

  Set<String> get all => {..._links};
}

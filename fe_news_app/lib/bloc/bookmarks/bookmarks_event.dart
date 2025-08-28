class BookmarksEvent {}

class LoadBookmarks extends BookmarksEvent {}

class FilteredBookmarks extends BookmarksEvent {
  final String? source;
  final String query;
  FilteredBookmarks({this.source, this.query = ''});
}

class AddBookmark extends BookmarksEvent {
  final Map<String, dynamic> item;
  AddBookmark(this.item);
}

class RemoveBookmark extends BookmarksEvent {
  final String link;
  RemoveBookmark(this.link);
}

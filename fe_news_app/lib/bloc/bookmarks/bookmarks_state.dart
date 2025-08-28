class BookmarkState {}

class BookmarkLoading extends BookmarkState {}

class BookmarkLoaded extends BookmarkState {
  final List<dynamic> bookmarks;
  final List<dynamic> filteredBookmarks;
  final Set<String> bookmarkedLinks;
  final String? selectedSource;

  BookmarkLoaded({
    required this.bookmarks,
    required this.filteredBookmarks,
    required this.bookmarkedLinks,
    required this.selectedSource,
  });
}

class BookmarkError extends BookmarkState {
  final String message;
  BookmarkError(this.message);
}

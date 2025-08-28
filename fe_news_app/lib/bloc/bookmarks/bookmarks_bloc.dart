import 'package:fe_news_app/bloc/bookmarks/bookmarks_event.dart';
import 'package:fe_news_app/bloc/bookmarks/bookmarks_state.dart';
import 'package:fe_news_app/services/bookmarks_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarksBloc extends Bloc<BookmarksEvent, BookmarkState> {
  BookmarksBloc() : super(BookmarkLoading()) {
    on<LoadBookmarks>(_onLoadBookmarks);
    on<FilteredBookmarks>(_onFilteredBookmarks);
    on<AddBookmark>(_onAddBookmark);
    on<RemoveBookmark>(_onRemoveBookmark);
  }

  Future<void> _onLoadBookmarks(
    LoadBookmarks event,
    Emitter<BookmarkState> emit,
  ) async {
    try {
      final data = await BookmarkService.getBookmarks();
      final links = data.map<String>((e) => e['link'] as String).toSet();

      emit(
        BookmarkLoaded(
          bookmarks: data,
          filteredBookmarks: data,
          bookmarkedLinks: links,
          selectedSource: '',
        ),
      );
    } catch (e) {
      emit(BookmarkError('Lỗi load bookmarks: $e'));
    }
  }

  void _onFilteredBookmarks(
    FilteredBookmarks event,
    Emitter<BookmarkState> emit,
  ) {
    if (state is BookmarkLoaded) {
      final current = state as BookmarkLoaded;
      final query = event.query.toLowerCase().trim();

      final filtered =
          current.bookmarks.where((item) {
            final title = (item['title'] ?? '').toString().toLowerCase();
            final source = (item['source'] ?? '').toString().toLowerCase();

            final matchesSource =
                event.source == null ||
                event.source!.isEmpty ||
                source == event.source!.toLowerCase();
            final matchesQuery =
                title.contains(query) || source.contains(query);

            return matchesSource && matchesQuery;
          }).toList();

      emit(
        BookmarkLoaded(
          bookmarks: current.bookmarks,
          filteredBookmarks: filtered,
          bookmarkedLinks: current.bookmarkedLinks,
          selectedSource: event.source,
        ),
      );
    }
  }

  Future<void> _onAddBookmark(
    AddBookmark event,
    Emitter<BookmarkState> emit,
  ) async {
    if (state is BookmarkLoaded) {
      final current = state as BookmarkLoaded;
      final success = await BookmarkService.createBookmark(event.item);

      if (success) {
        final updatedBookmarks = [...current.bookmarks, event.item];
        final updatedLinks = {
          ...current.bookmarkedLinks,
          (event.item['link'] as String),
        };

        emit(
          BookmarkLoaded(
            bookmarks: updatedBookmarks,
            filteredBookmarks: updatedBookmarks,
            bookmarkedLinks: updatedLinks,
            selectedSource: '',
          ),
        );
      }
    }
  }

  Future<void> _onRemoveBookmark(
    RemoveBookmark event,
    Emitter<BookmarkState> emit,
  ) async {
    if (state is BookmarkLoaded) {
      final current = state as BookmarkLoaded;
      final success = await BookmarkService.deleteBookmark(event.link);

      if (success) {
        final updatedBookmarks =
            current.bookmarks.where((b) => b['link'] != event.link).toList();
        final updatedLinks = {...current.bookmarkedLinks}..remove(event.link);

        emit(
          BookmarkLoaded(
            bookmarks: updatedBookmarks,
            filteredBookmarks: updatedBookmarks,
            bookmarkedLinks: updatedLinks,
            selectedSource: '',
          ),
        );
      }
    }
  }
}

const bookmarkService = require('../services/bookmarks.service');

const createBookmark = async (req, res) => {
  try {
    const userId = req.user.id;
    const bookmark = await bookmarkService.createBookmark(userId, req.body);
    res.status(201).json(bookmark);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getBookmarks = async (req, res) => {
  try {
    const userId = req.user.id;
    const bookmarks = await bookmarkService.getBookmarksByUser(userId);
    res.json(bookmarks);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const deleteBookmark = async (req, res) => {
  try {
    const userId = req.user.id;
    const { id } = req.params;
    await bookmarkService.deleteBookmark(userId, id);
    res.json({ message: 'Deleted successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = {
  createBookmark,
  getBookmarks,
  deleteBookmark,
};

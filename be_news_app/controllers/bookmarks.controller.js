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

const deleteBookmarkByLink = async (req, res) => {
  const userId = req.user.id;
  const { link } = req.query;

  if (!link) {
    return res.status(400).json({ message: 'Missing link' });
  }

  try {
    const deleted = await bookmarkService.deleteBookmarkByLink(userId, link);
    if (!deleted) {
      return res.status(404).json({ message: 'Bookmark not found' });
    }
    res.json({ message: 'Bookmark has been deleted successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = {
  createBookmark,
  getBookmarks,
  deleteBookmarkByLink,
};

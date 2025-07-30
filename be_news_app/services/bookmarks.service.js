const { Bookmarks } = require('../models');

const createBookmark = async (userId, data) => {
  return await Bookmarks.create({ ...data, userId });
};

const getBookmarksByUser = async (userId) => {
  return await Bookmarks.findAll({
    where: { userId },
    order: [['createdAt', 'DESC']],
  });
};

const deleteBookmark = async (userId, id) => {
  return await Bookmarks.destroy({
    where: { id, userId },
  });
};

module.exports = {
  createBookmark,
  getBookmarksByUser,
  deleteBookmark,
};

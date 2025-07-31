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

const deleteBookmarkByLink = async (userId, link) => {
  const deleted = await Bookmarks.destroy({
    where: { userId, link }
  });
  return deleted > 0;
};

module.exports = {
  createBookmark,
  getBookmarksByUser,
  deleteBookmarkByLink,
};

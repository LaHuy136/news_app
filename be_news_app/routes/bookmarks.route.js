const express = require('express');
const router = express.Router();
const bookmarkController = require('../controllers/bookmarks.controller');
const authMiddleware = require('../middlewares/auth.middleware');

router.use(authMiddleware); 

router.post('/', bookmarkController.createBookmark);
router.get('/', bookmarkController.getBookmarks);
router.delete('/:id', bookmarkController.deleteBookmark);

module.exports = router;

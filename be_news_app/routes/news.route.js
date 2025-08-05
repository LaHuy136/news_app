const express = require('express');
const router = express.Router();
const { getNews, getMixedNews } = require('../controllers/news.controller');

router.get('/mixed', getMixedNews);
router.get('/:category', getNews);

module.exports = router;

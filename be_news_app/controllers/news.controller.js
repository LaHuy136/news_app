const newsService = require('../services/news.service');

async function getNews(req, res) {
  const { category } = req.params;

  try {
    const news = await newsService.getNewsByCategory(category);
    res.json({ category, items: news });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getMixedNews(req, res) {
  try {
    const { categories } = req.query;

    if (!categories) {
      return res.status(400).json({ error: 'Missing categories' });
    }

    const categoryList = categories.split(',').map(c => c.trim());

    const mixedNews = await newsService.getMixedNewsByCategory(categoryList);
    return res.json(mixedNews);
  } catch (err) {
    console.error('Error in getMixedNewsController:', err);
    return res.status(500).json({ error: 'Internal server error' });
  }
}

module.exports = { getNews, getMixedNews };

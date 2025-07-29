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

module.exports = { getNews };

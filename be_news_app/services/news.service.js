const { News } = require('../models');
const parseRSS = require('../utils/rssParser');

const feedUrls = {
  'noi-bat-vnexpress': 'https://vnexpress.net/rss/tin-noi-bat.rss',
  'the-gioi-vnexpress': 'https://vnexpress.net/rss/the-gioi.rss',
  'cong-nghe-vnexpress': 'https://vnexpress.net/rss/so-hoa.rss',
  'the-thao-vnexpress': 'https://vnexpress.net/rss/the-thao.rss',
  'doi-song-vnexpress': 'https://vnexpress.net/rss/doi-song.rss',
  'giai-tri-vnexpress': 'https://vnexpress.net/rss/giai-tri.rss',
  'xe-vnexpress': 'https://vnexpress.net/rss/oto-xe-may.rss',
  'cuoi-vnexpress': 'https://vnexpress.net/rss/cuoi.rss',
  'giao-duc-vnexpress': 'https://vnexpress.net/rss/giao-duc.rss',
  'thoi-su-vnexpress': 'https://vnexpress.net/rss/thoi-su.rss',
  'suc-khoe-vnexpress': 'https://vnexpress.net/rss/suc-khoe.rss',
};

async function getNewsByCategory(category) {
  const url = feedUrls[category];
  if (!url) throw new Error('Invalid category');

  const newsList = await parseRSS(url);

  for (const item of newsList) {
    await News.findOrCreate({
      where: { link: item.link },
      defaults: { ...item, category }
    });
  }

  return newsList;
}

module.exports = { getNewsByCategory };

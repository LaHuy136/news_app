const { News } = require('../models');
const parseRSS = require('../utils/rssParser');

const feedUrls = {
  'noi-bat-vnexpress': 'https://vnexpress.net/rss/tin-noi-bat.rss',

  'the-gioi-vnexpress': 'https://vnexpress.net/rss/the-gioi.rss',
  'the-gioi-tuoitre': 'https://tuoitre.vn/rss/the-gioi.rss',
  // 'the-gioi-thanhnien': 'https://thanhnien.vn/rss/the-gioi.rss',

  'cong-nghe-vnexpress': 'https://vnexpress.net/rss/so-hoa.rss',
  'cong-nghe-tuoitre': 'https://tuoitre.vn/rss/nhip-song-so.rss',
  // 'cong-nghe-thanhnien': 'https://thanhnien.vn/rss/cong-nghe.rss',


  'the-thao-vnexpress': 'https://vnexpress.net/rss/the-thao.rss',
  'the-thao-tuoitre': 'https://tuoitre.vn/rss/the-thao.rss',
  // 'the-thao-thanhnien': 'https://thanhnien.vn/rss/the-thao.rss',

  'doi-song-vnexpress': 'https://vnexpress.net/rss/doi-song.rss',
  'doi-song-tuoitre': 'https://tuoitre.vn/rss/nhip-song-tre.rss',
  // 'doi-song-thanhnien': 'https://thanhnien.vn/rss/doi-song.rss',


  'giai-tri-vnexpress': 'https://vnexpress.net/rss/giai-tri.rss',
  'giai-tri-tuoitre': 'https://tuoitre.vn/rss/giai-tri.rss',
  // 'giai-tri-thanhnien': 'https://thanhnien.vn/rss/giai-tri.rss',


  'xe-vnexpress': 'https://vnexpress.net/rss/oto-xe-may.rss',
  'xe-tuoitre': 'https://tuoitre.vn/rss/xe.rss',
  // 'xe-thanhnien': 'https://thanhnien.vn/rss/xe.rss',


  'cuoi-vnexpress': 'https://vnexpress.net/rss/cuoi.rss',
  'cuoi-tuoitre': 'https://tuoitre.vn/rss/thu-gian.rss',


  'giao-duc-vnexpress': 'https://vnexpress.net/rss/giao-duc.rss',
  'giao-duc-tuoitre': 'https://tuoitre.vn/rss/giao-duc.rss',
  // 'giao-duc-thanhnien': 'https://thanhnien.vn/rss/giao-duc.rss',


  'thoi-su-vnexpress': 'https://vnexpress.net/rss/thoi-su.rss',
  'thoi-su-tuoitre': 'https://tuoitre.vn/rss/thoi-su.rss',
  // 'thoi-su-thanhnien': 'https://thanhnien.vn/rss/thoi-su.rss',


  'suc-khoe-vnexpress': 'https://vnexpress.net/rss/suc-khoe.rss',
  'suc-khoe-tuoitre': 'https://tuoitre.vn/rss/suc-khoe.rss',
  // 'suc-khoe-thanhnien': 'https://thanhnien.vn/rss/suc-khoe.rss',
 
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

async function getMixedNewsByCategory(categories = [], saveToDB = true) {
  if (!Array.isArray(categories) || categories.length < 2) {
    throw new Error('At least two categories are required to mix');
  }

  const results = await Promise.all(
    categories.map(async (category) => {
      const url = feedUrls[category];
      if (!url) throw new Error(`Invalid category: ${category}`);

      const newsList = await parseRSS(url);

      if (saveToDB) {
        for (const item of newsList) {
          await News.findOrCreate({
            where: { link: item.link },
            defaults: { ...item, category },
          });
        }
      }

      // Shuffle
      return shuffleArray(newsList);
    })
  );

  const maxLength = Math.max(...results.map(r => r.length));
  const mixed = [];

  for (let i = 0; i < maxLength; i++) {
    for (const list of results) {
      if (i < list.length) {
        mixed.push(list[i]);
      }
    }
  }

  return mixed;
}

function shuffleArray(arr) {
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
}



module.exports = { getNewsByCategory, getMixedNewsByCategory };

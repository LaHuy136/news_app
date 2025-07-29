const axios = require('axios');
const xml2js = require('xml2js');

function extractImage(description) {
  const match = description?.match(/<img[^>]+src="([^">]+)"/);
  return match ? match[1] : null;
}

function extractTextAfterImage(description) {
  const parts = description.split('</a></br>');
  return parts[1]?.trim() || '';
}

async function parseRSS(url) {
  const res = await axios.get(url);
  const result = await xml2js.parseStringPromise(res.data);
  const channel = result.rss.channel[0];

  return result.rss.channel[0].item.map(item => ({
    channelTitle: channel.title[0],
    title: item.title[0],
    link: item.link[0],
    pubDate: item.pubDate?.[0],
    // description: item.description?.[0],
    thumbnail: extractImage(item.description?.[0]),
    alt: extractTextAfterImage(item.description?.[0]) || item.title?.[0],
    // thumbnailTitle: item.title?.[0],
  }));
}

module.exports = parseRSS;

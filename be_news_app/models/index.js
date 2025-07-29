// models/index.js
const { Sequelize } = require('sequelize');

const sequelize = new Sequelize('news_app', 'postgres', 'admin', {
  host: 'localhost',
  dialect: 'postgres',
});

const NewsModel = require('./news.model');
const News = NewsModel(sequelize, Sequelize.DataTypes);

module.exports = {
  sequelize,
  News,
};

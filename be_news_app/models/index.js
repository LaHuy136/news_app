const { Sequelize } = require('sequelize');

const sequelize = new Sequelize('news_app', 'postgres', 'admin', {
  host: 'localhost',
  dialect: 'postgres',
});

const UsersModel = require('./users.model');
const NewsModel = require('./news.model');
const BookmarksModel = require('./bookmarks.model');
const OTPVerificationModel = require('./otpVerification.model');

const Users = UsersModel(sequelize, Sequelize.DataTypes);
const News = NewsModel(sequelize, Sequelize.DataTypes);
const Bookmarks = BookmarksModel(sequelize, Sequelize.DataTypes);
const OTPVerification = OTPVerificationModel(sequelize, Sequelize.DataTypes);

// Thiết lập quan hệ
Users.hasMany(Bookmarks, { foreignKey: 'userId', onDelete: 'CASCADE' });
Bookmarks.belongsTo(Users, { foreignKey: 'userId' });

module.exports = {
  sequelize,
  Users,
  News,
  Bookmarks,
  OTPVerification,
};

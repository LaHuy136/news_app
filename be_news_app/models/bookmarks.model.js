module.exports = (sequelize, DataTypes) => {
    const Bookmark = sequelize.define('Bookmark', {
        newsId: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        title: DataTypes.STRING,
        link: DataTypes.STRING,
        thumbnail: DataTypes.STRING,
        source: DataTypes.STRING,
        pubDate: DataTypes.STRING,
    });

    Bookmark.associate = (models) => {
        Bookmark.belongsTo(models.User, { foreignKey: 'userId' });
    };

    return Bookmark;
};

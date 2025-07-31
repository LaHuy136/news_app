module.exports = (sequelize, DataTypes) => {
    const Bookmark = sequelize.define('Bookmark', {
        title: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        link: {
            type: DataTypes.STRING,
            allowNull: false,
            unique: true, 
        },
        thumbnail: {
            type: DataTypes.STRING,
        },
        source: {
            type: DataTypes.STRING,
        },
        pubDate: {
            type: DataTypes.STRING,
        },
    });

    Bookmark.associate = (models) => {
        Bookmark.belongsTo(models.User, { foreignKey: 'userId' });
    };

    return Bookmark;
};

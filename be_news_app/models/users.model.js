module.exports = (sequelize, DataTypes) => {
  const User = sequelize.define('User', {
    email: {
      type: DataTypes.STRING,
      unique: true,
      allowNull: false,
    },
    password: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    username: DataTypes.STRING,
    firebaseUid: {
      type: DataTypes.STRING,
      unique: true,
      allowNull: true,
    },

  });

  User.associate = (models) => {
    User.hasMany(models.Bookmark, { foreignKey: 'userId', onDelete: 'CASCADE' });
  };

  return User;
};

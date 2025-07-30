// models/otp_verification.model.js
module.exports = (sequelize, DataTypes) => {
  const OTPVerification = sequelize.define('OTPVerification', {
    email: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    otp: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    expiresAt: {
      type: DataTypes.DATE,
      allowNull: false,
    },
  });

  return OTPVerification;
};

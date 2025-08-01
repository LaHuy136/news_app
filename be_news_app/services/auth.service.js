const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');
const { OTPVerification, Users } = require('../models');
const bcrypt = require('bcryptjs');
const admin = require('../firebase');
const generateEmailTemplate = require('../utils/emailTemplate');

const register = async ({ email, password, username }) => {
    const existing = await Users.findOne({ where: { email } });
    if (existing) {
        throw new Error('Email already registered');
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const user = await Users.create({ email, password: hashedPassword, username });

    return {
        user: {
            id: user.id,
            email: user.email,
            username: user.name,
        },
    };
};


const login = async ({ email, password }) => {
    const user = await Users.findOne({ where: { email } });
    if (!user) {
        throw new Error('User not found');
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
        throw new Error('Invalid credentials');
    }

    const token = jwt.sign(
        { id: user.id },
        process.env.JWT_SECRET || 'secret',
        { expiresIn: '7d' }
    );

    return {
        token,
        user: {
            id: user.id,
            email: user.email,
            name: user.name,
        },
    };
};

const loginWithFirebaseToken = async (firebaseIdToken) => {
    let decoded;
    try {
        decoded = await admin.auth().verifyIdToken(firebaseIdToken);
    } catch (err) {
        throw new Error('Invalid Firebase ID token');
    }

    const email = decoded.email;
    const username = decoded.name || '';
    const firebaseUid = decoded.uid;

    if (!email) {
        throw new Error('Firebase token missing email');
    }

    // Tìm user theo email hoặc firebaseUid
    let user = await Users.findOne({
        where: {
            email,
        },
    });

    if (!user) {
        // Tạo mới, dùng name làm username nếu có, fallback lấy phần trước @
        const usernameFallback = username.trim().length > 0
            ? username
            : email.split('@')[0];

        user = await Users.create({
            email,
            username: usernameFallback,
            firebaseUid,
        });
    } else if (!user.firebaseUid) {
        // Gắn firebaseUid nếu chưa có
        user.firebaseUid = firebaseUid;
        await user.save();
    }

    const token = jwt.sign(
        { id: user.id },
        process.env.JWT_SECRET || 'secret',
        { expiresIn: '7d' }
    );

    return {
        token,
        user: {
            id: user.id,
            email: user.email,
            username: user.username,
        },
    };
};


const updateUserInfo = async (userId, updateData) => {
    const user = await Users.findByPk(userId);
    if (!user) throw new Error('User not found');

    user.email = updateData.email || user.email;
    user.username = updateData.username || user.username;

    await user.save();
    return user;
};


const getUserById = async (userId) => {
    const user = await Users.findByPk(userId, {
        attributes: ['id', 'email', 'username'],
    });

    if (!user) throw new Error('User not found');
    return user;
};




const generateOTP = () => Math.floor(100000 + Math.random() * 900000).toString();

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASSWORD,
    },
});

const requestPasswordReset = async (email) => {
    const user = await Users.findOne({ where: { email } });
    if (!user) throw new Error('Email not registered');

    const otp = generateOTP();
    const expiresAt = new Date(Date.now() + 5 * 60 * 1000); // 5 phút

    await OTPVerification.create({ email, otp, expiresAt });

    // Gửi email
    await transporter.sendMail({
        from: `"News App" <${process.env.EMAIL_USER}>`,
        to: email,
        subject: '🔐 OTP cập nhật mật khẩu',
        html: generateEmailTemplate(user.username, otp),
    });

    return { message: 'OTP sent to email' };
};

const resetPasswordWithOTP = async (email, otp, newPassword) => {
    const record = await OTPVerification.findOne({ where: { email, otp } });
    if (!record) throw new Error('Invalid OTP');

    if (new Date() > record.expiresAt) {
        await OTPVerification.destroy({ where: { email, otp } });
        throw new Error('OTP expired');
    }

    const hashed = await bcrypt.hash(newPassword, 10);
    await Users.update({ password: hashed }, { where: { email } });
    await OTPVerification.destroy({ where: { email } });

    return { message: 'Password updated successfully' };
};

const verifyCode = async (email, otp) => {
    const record = await OTPVerification.findOne({ where: { email, otp } });

    if (!record) throw new Error('Invalid OTP');

    if (new Date() > record.expiresAt) {
        await OTPVerification.destroy({ where: { email, otp } });
        throw new Error('OTP expired');
    }

    return { message: 'OTP is valid' };
};


module.exports = {
    register,
    login,
    loginWithFirebaseToken,
    requestPasswordReset,
    resetPasswordWithOTP,
    verifyCode,
    updateUserInfo,
    getUserById,
};

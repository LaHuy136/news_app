const authService = require('../services/auth.service');

const register = async (req, res) => {
    try {
        const data = await authService.register(req.body);
        res.status(201).json(data);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
};

const login = async (req, res) => {
    try {
        const data = await authService.login(req.body);
        res.json(data);
    } catch (err) {
        res.status(401).json({ message: err.message });
    }
};


const googleFirebaseLogin = async (req, res) => {
    const { idToken } = req.body;
    if (!idToken) {
        return res.status(400).json({ error: 'Missing Firebase ID token' });
    }
    try {
        const result = await authService.loginWithFirebaseToken(idToken);
        res.status(200).json({
            message: 'Google login successful',
            token: result.token,
            user: result.user,
        });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};

const getUserById = async (req, res) => {
    const userId = req.user.id;

    try {
        const user = await authService.getUserById(userId);
        return res.json({ user });
    } catch (err) {
        if (err.message === 'User not found') {
            return res.status(404).json({ message: 'User not found' });
        }
        return res.status(500).json({ message: err.message });
    }
};


const updateUser = async (req, res) => {
    const userId = req.user.id;
    const { email, username, } = req.body;

    try {
        const user = await authService.updateUserInfo(userId, {
            email,
            username,
        });

        return res.json({ message: 'User updated successfully', user });
    } catch (err) {
        if (err.message === 'User not found') {
            return res.status(404).json({ message: 'User not found' });
        }

        return res.status(500).json({ message: err.message });
    }
};



const requestOTP = async (req, res) => {
    try {
        const { email } = req.body;
        const result = await authService.requestPasswordReset(email);
        res.json(result);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
};

const resetPassword = async (req, res) => {
    try {
        const { email, otp, newPassword } = req.body;
        const result = await authService.resetPasswordWithOTP(email, otp, newPassword);
        res.json(result);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
};

const verifyCode = async (req, res) => {
    const { email, otp } = req.body;

    try {
        const result = await authService.verifyCode(email, otp);
        res.json(result);
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};


module.exports = {
    register,
    login,
    googleFirebaseLogin,
    requestOTP,
    resetPassword,
    verifyCode,
    updateUser,
    getUserById,
};

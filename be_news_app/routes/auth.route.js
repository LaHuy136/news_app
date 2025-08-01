const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');
const authMiddleware = require('../middlewares/auth.middleware');

router.post('/register', authController.register);
router.post('/google-login', authController.googleFirebaseLogin);

router.use(authMiddleware); 

router.get('/',  authController.getUserById);
router.post('/login', authController.login);
router.post('/request-otp', authController.requestOTP);
router.post('/reset-password', authController.resetPassword);
router.post('/verify-code', authController.verifyCode);
router.put('/update', authController.updateUser);

module.exports = router;

const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');
const authMiddleware = require('../middlewares/auth.middleware');

router.use(authMiddleware); 

router.get('/',  authController.getUserById);
router.post('/register', authController.register);
router.post('/login', authController.login);
router.post('/request-otp', authController.requestOTP);
router.post('/reset-password', authController.resetPassword);
router.post('/verify-code', authController.verifyCode);
router.put('/update', authController.updateUser);

module.exports = router;

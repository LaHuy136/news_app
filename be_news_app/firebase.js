const admin = require("firebase-admin");
const serviceAccount = require("../be_news_app/serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

module.exports = admin;
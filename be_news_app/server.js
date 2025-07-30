const express = require('express');
const dotenv = require('dotenv');
const { sequelize } = require('./models');

dotenv.config();
const app = express();

app.use(express.json());
app.use('/news', require('./routes/news.route'));
app.use('/bookmarks', require('./routes/bookmarks.route'));
app.use('/auth', require('./routes/auth.route'));

const PORT = process.env.PORT || 3000;

(async () => {
  try {
    await sequelize.sync(); 
    app.listen(PORT, () => {
      console.log(`Server running at http://localhost:${PORT}`);
    });
  } catch (err) {
    console.error('Failed to start:', err);
  }
})();

const bodyParser = require('./body-parser.middleware');

module.exports = (app) => {
    bodyParser(app);
}
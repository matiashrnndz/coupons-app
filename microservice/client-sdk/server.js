const express = require('express');
const app = express();

const useMiddlewares = require('./middlewares');
const routes = require('./routes');

useMiddlewares(app);
routes(app);

app.listen(process.env.PORT || 3001 , () => {
    console.log(`Server listening on port: ${process.env.PORT || 3001}`);
});
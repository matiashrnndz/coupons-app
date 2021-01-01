const express = require('express');
const app = express();
const promoStatServices = require('./business_logic/services/statistics.service');
const opentracing = require('opentracing');
var lightstep = require('lightstep-tracer');

var tracer = new lightstep.Tracer({
    component_name : 'app-coupons-reports',
    access_token : '/AzmaRAXPS/SPIEzjb+pDDY32SQyruDC7wQkPKwzohUaE9SOp015NqUWrC2OaxYr0VoxM66nvSTdihdrM19rJO0ZEp7bdpwjUe2+8Gh/',
});
opentracing.initGlobalTracer(tracer);

require('dotenv').config();
const useMiddlewares = require('./middlewares');
const routes = require('./routes');

const mongoose = require('mongoose');
mongoose.set('useFindAndModify',false); 
const mongoDB = process.env.DB_URL;
mongoose.connect(mongoDB, { useNewUrlParser:true });  
mongoose.Promise = global.Promise;
const db = mongoose.connection;
db.on('error', console.error.bind(console, 'MongoDB connection error:'));

useMiddlewares(app);
routes(app);

promoStatServices.receiveEvaluations();

app.listen(process.env.PORT, () => {
    console.log(`Server listening on port: ${process.env.PORT}`);
});
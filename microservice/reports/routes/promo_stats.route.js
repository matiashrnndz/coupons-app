const promoStatLogic = require('../business_logic/promo_stats.logic');
const authLogic = require('../business_logic/authorization.logic');
const e = require('../exceptions/exceptions');

const { FORMAT_HTTP_HEADERS } = require('opentracing')
const opentracing = require('opentracing');

module.exports = function (app){

/*    
    app.post('/api/promo_stats', async (req, res) => {

        console.log("[POST] /api/promo_stats");  
        console.log("BODY:");
        console.log(req.body);
        console.log("HEADERS:");
        console.log(req.headers);

        try{
            promoStat = await promoStatLogic.processStatistic(req.body);
            res.status(201).send(promoStat);
            console.log("Promo Stat Created!");

        }catch(error){
            switch(error.name){
                case e.InvalidDataReceived: 
                    res.status(400).send(error.message);
                    console.log('info ' + error.message);
                    break;
                case e.InvalidCredentials: 
                    res.status(401).send(error.message);
                    console.log('info ' + error.message);
                    break;
                case e.Forbidden: 
                    res.status(403).send(error.message);
                    console.log('info ' + error.message);
                    break;    
                default:
                    console.log('error ' + error.message);
                    console.log('error ' + error.name);
                    res.status(500).send();
            }
        }
    });
*/
/*
    app.get('/api/promo_stats', async (req, res) => {

        console.log("[GET] /api/promo_stats");  

        try{
            promosStats = await promoStatLogic.getAllPromoStatistics();
            res.status(200).send(promosStats);
            console.log("All Promo Stats Retrieved!");

        }catch(error){
            switch(error.name){
                case e.InvalidDataReceived: 
                    res.status(400).send(error.message);
                    console.log('info ' + error.message);
                    break;
                case e.InvalidCredentials: 
                    res.status(401).send(error.message);
                    console.log('info ' + error.message);
                    break;
                case e.Forbidden: 
                    res.status(403).send(error.message);
                    console.log('info ' + error.message);
                    break;    
                default:
                    console.log('error ' + error.message);
                    console.log('error ' + error.name);
                    res.status(500).send();
            }
        }
    });
*/
/*
    app.get('/api/promo_stats/:id', async (req, res) => {

        try{
            console.log("[GET] /api/promo_stats/" + req.params.id);  

            promoId = req.params.id;
            promosStats = await promoStatLogic.getPromoStatisticsByPromoId(promoId);
            res.status(200).send(promosStats);
            console.log("Promo Stats Retrieved by Promo Id!");

        }catch(error){
            switch(error.name){
                case e.InvalidDataReceived: 
                    res.status(400).send(error.message);
                    console.log('info ' + error.message);
                    break;
                case e.InvalidCredentials: 
                    res.status(401).send(error.message);
                    console.log('info ' + error.message);
                    break;
                case e.Forbidden: 
                    res.status(403).send(error.message);
                    console.log('info ' + error.message);
                    break;    
                default:
                    console.log('error ' + error.message);
                    console.log('error ' + error.name);
                    res.status(500).send();
            }
        }
    });
*/
/*
    app.delete('/api/promo_stats/:id', async (req, res) => {
         
        try{
            console.log("[DELETE] /api/promo_stats/" + req.params.id);  

            promoId = req.params.id;
            promosStats = await promoStatLogic.deletePromoStatisticsByPromoId(promoId);
            res.status(200).send(promosStats);
            console.log("Promo Stats Deleted by Promo Id!");

        }catch(error){
            switch(error.name){
                case e.InvalidDataReceived: 
                    res.status(400).send(error.message);
                    console.log('info ' + error.message);
                    break;
                case e.InvalidCredentials: 
                    res.status(401).send(error.message);
                    console.log('info ' + error.message);
                    break;
                case e.Forbidden: 
                    res.status(403).send(error.message);
                    console.log('info ' + error.message);
                    break;    
                default:
                    console.log('error ' + error.message);
                    console.log('error ' + error.name);
                    res.status(500).send();
            }
        }
    });
*/

    app.get('/api/promo_stats/:id/summary', async (req, res) => {

        try{
            console.log("[GET] /api/promo_stats/" + req.params.id + "/summary");  

            //trace 
            const reportSpan = opentracing.globalTracer().startSpan('get_report_summary', {
                tags :{
                  'http.method' : 'GET',
                  'http.url': `http://${req.headers.host}${req.url}`,
                  'promo.id': req.params.id
                }
            });

            opentracing.globalTracer().inject(reportSpan.context(), FORMAT_HTTP_HEADERS, req.headers)
            reportSpan.setTag(opentracing.Tags.HTTP_STATUS_CODE, res.statusCode)
            reportSpan.log({
                'event': 'request_end'
            });
            //end trace
            
            const token = req.headers.authorization;
            promoId = req.params.id;
            await authLogic.isAuthorized(token, promoId);

            summary = await promoStatLogic.getPromoStatsSummary(promoId);
            res.status(200).send(summary);
            console.log("Promo Stats Summary Retrieved!");

            //trace
            reportSpan.finish();
            //end trace

        }catch(error){
            switch(error.name){
                case e.InvalidDataReceived: 
                    res.status(400).send(error.message);
                    console.log('info ' + error.message);
                    break;
                case e.InvalidCredentials: 
                    res.status(401).send(error.message);
                    console.log('info ' + error.message);
                    break;
                case e.Forbidden: 
                    res.status(403).send(error.message);
                    console.log('info ' + error.message);
                    break;    
                default:
                    console.log('error ' + error.message);
                    console.log('error ' + error.name);
                    res.status(500).send();
            }
        }
    });

    app.get('/api/promo_stats/:id/demographic', async (req, res) => {

        try{
            console.log("[GET] /api/promo_stats/" + req.params.id + "/demographic");  

            //trace 
            const reportSpan = opentracing.globalTracer().startSpan('get_report_demographic', {
                tags :{
                  'http.method' : 'GET',
                  'http.url': `http://${req.headers.host}${req.url}`,
                  'promo.id': req.params.id
                }
            });

            opentracing.globalTracer().inject(reportSpan.context(), FORMAT_HTTP_HEADERS, req.headers)
            reportSpan.setTag(opentracing.Tags.HTTP_STATUS_CODE, res.statusCode)
            reportSpan.log({
                'event': 'request_end'
            });
            //end trace
            
            var queryFilter = {};
            queryFilter.country = req.query.country;
            queryFilter.city = req.query.city;
            queryFilter.age = req.query.age;            

            const token = req.headers.authorization;
            promoId = req.params.id;
            await authLogic.isAuthorized(token, promoId);

            demographic = await promoStatLogic.getPromoStatsDemographic(promoId, queryFilter);
            res.status(200).send(demographic);
            console.log("Promo Demographic Stats Retrieved!");

            //trace
            reportSpan.finish();
            //end trace

        }catch(error){
            switch(error.name){
                case e.InvalidDataReceived: 
                    res.status(400).send(error.message);
                    console.log('info ' + error.message);
                    break;
                case e.InvalidCredentials: 
                    res.status(401).send(error.message);
                    console.log('info ' + error.message);
                    break;
                case e.Forbidden: 
                    res.status(403).send(error.message);
                    console.log('info ' + error.message);
                    break;    
                default:
                    console.log('error ' + error.message);
                    console.log('error ' + error.name);
                    res.status(500).send();
            }
        }
    });

};
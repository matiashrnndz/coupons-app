const e = require('../exceptions/exceptions');
const clientLogic = require('../business_logic/client.logic');
const path = require ('path');

module.exports = function (app){
    app.post('/process', async (req, res) => {

        try{
            console.log('\n\n*** CLIENT request data ****');
            console.log(req.body);
            console.log('****************************');

            resp = await clientLogic.requestEvaluation(req.body);

            console.log("\n\n*** CLIENT response data ***");
            console.log(resp);
            console.log("****************************");
            
            res.status(200).send(resp);
            
        }catch(error){
            switch(error.name){
                case e.InvalidDataReceived: 
                    res.status(400).send(error.message);
                    break;
                case e.InvalidCredentials: 
                    res.status(401).send(error.message);
                    break;
                case e.Forbidden: 
                    res.status(403).send(error.message);
                    break;    
                case e.NetworkError:
                        res.status(500).send(error.message);
                default:
                    res.status(500).send();
            }
        }

    });

    app.get('/', async (req, res) => {

        //desde la carpeta routes
        //res.sendFile(path.join(__dirname, '/index.html')); 
        //desde public
        res.sendFile (path.join (__dirname, '../public', 'index.html'));

    });
};
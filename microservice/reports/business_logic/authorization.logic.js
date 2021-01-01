const promoStatDA = require('../data_access/promo_stats.da');
const e = require('../exceptions/exceptions');
const jwt = require('jsonwebtoken');

async function isAuthorized(token, promoId){ 
    var payload = null;
    if(token){
        jwt.verify(token, process.env.SECRET_KEY_BASE, (err, decoded) => {
            if(err){
                //console.log(err);
                throw {name : e.InvalidCredentials, message : "Invalid Credentials."};        
            }else{
                payload = decoded;
                //console.log(payload);
            }
        });
    }else{
        throw {name : e.InvalidCredentials, message : "Invalid Credentials."};
    }

    const query = {'promotion_definition_id': promoId};
    promoStat = await promoStatDA.getPromoStat(query);

    if(!promoStat){
        throw {name : e.InvalidDataReceived, message : "PromoId does not exists."};
    }
    
    if(!payload.codes.includes(promoStat.code)){
        throw {name : e.Forbidden, message : "Do not have proper authorization level."};
    }

    return;
};

module.exports.isAuthorized = isAuthorized;
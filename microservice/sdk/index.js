const evaluationService = require('./services/evaluation.service')

async function requestEvaluationJsonFormat(dataToEval){ 

    header = {};
    header.Authorization = dataToEval.token;

    delete dataToEval['token'];
    
    resp = await evaluationService.evaluatePromotion(header, dataToEval);
    
    console.log('\n\n### SDK Library ###');
    console.log('evaluatePromotion response');
    console.log(resp);
    console.log('###################');

    if(!resp)
        throw {name : e.NetworkError, message: 'Network Error, no data received'};

    return resp;
};

async function requestEvaluationSeveralParamsFormat(token, promo_code, total, promo_type, txnid_or_couponcode, attr_list, country='', city='', birthday=''){

    header = {};
    header.Authorization = token;

    var dataToEval = {};
    dataToEval.code = promo_code;
    dataToEval.metadata = {};
    dataToEval.metadata.total = total;
    
    if (country != null && country.trim().length != 0 && country != ''){
        dataToEval.metadata.country = country;
    }
    if (city != null && city.trim().length != 0 && city != ''){
        dataToEval.metadata.city = city;
    }
    if (birthday != null && birthday.trim().length != 0 && birthday != ''){
        dataToEval.metadata.birthday = birthday;
    }

    if(promo_type === 'coupon'){
        dataToEval.metadata.coupon_code = txnid_or_couponcode;
    }else{ //discount
        dataToEval.metadata.transaction_id = txnid_or_couponcode;
    }
    dataToEval.metadata.attributes = attr_list;

    resp = await evaluationService.evaluatePromotion(header, dataToEval);

    console.log('\n\n### SDK Library ###');
    console.log('evaluatePromotion response');
    console.log(resp);
    console.log('###################');

    if(!resp)
        throw {name : e.NetworkError, message: 'Network Error, no data received'};

    return resp;
}

module.exports.requestEvaluationJsonFormat = requestEvaluationJsonFormat;
module.exports.requestEvaluationSeveralParamsFormat = requestEvaluationSeveralParamsFormat;

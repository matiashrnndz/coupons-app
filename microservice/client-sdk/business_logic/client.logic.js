const couponsSDK = require('coupons-sdk');

async function requestEvaluation(dataToEval){

    console.log('data sent to SDK:');
    console.log(dataToEval);

    resp = await couponsSDK.requestEvaluationJsonFormat(dataToEval);
    
    return resp;
}

module.exports.requestEvaluation = requestEvaluation;

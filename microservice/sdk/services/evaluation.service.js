const requestEval = require('request');

async function evaluatePromotion(headerToSend, bodyToSend){

  console.log('\n\n### SDK Library ###');
  console.log('evaluatePromotion request');
  console.log('header:')
  console.log(headerToSend);
  console.log('body:');
  console.log(bodyToSend);
  console.log('###################');

  const EVAL_URL = "https://app-webproxy.herokuapp.com/promotions/evaluation";

  return new Promise(function (resolve, reject) {
      requestEval.post(EVAL_URL,
          {
              json:true,
              headers: headerToSend,
              body: bodyToSend,
              timeout: 3000
          },
          (error, response, body) => {
              if(error){
                  console.log(error);
                  console.log('statusCode:', response && response.statusCode);
                  resolve(error);
              }else{
                console.log('statusCode:', response && response.statusCode);
                resolve(body);
              }
          });
  })

}

module.exports.evaluatePromotion = evaluatePromotion;

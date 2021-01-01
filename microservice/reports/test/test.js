var assert = require('assert');
const authLogic = require('../business_logic/authorization.logic');
const promoStatLogic = require('../business_logic/promo_stats.logic');
const e = require('../exceptions/exceptions');
require('dotenv').config();
const mongoose = require('mongoose');

mongoose.connect(process.env.DB_URL, { useNewUrlParser:true });  

const tokenValid = 'eyJhbGciOiJIUzI1NiJ9.eyJjb2RlcyI6WyJNbklyZDFHayJdLCJuYW1lIjoiYWxnbyIsImV4cCI6MTU3NDkwNDM1MX0.YuJAA18iPnxedGbrYJlGdwQ-OaaRkPPBWBeXrjrqDWs';
const tokenInvalid = 'truchociOiJIUzI1NiJ9.eyJjb2RlcyI6WyIyWlVkT2xlRCJdLCJuYW1lIjoidW4gbm9tYnJlIiwiZXhwIjoxNTczNTIxMjI3fQ.-a1eVHc13kY89Ad9n7wEy3sowsjP3gl0vi7sY7mXLQY';

// if token not present                     -> InvalidCredentials Exception
// if token in not valid                    -> InvalidCredentials Exception
// if promoId does not exists               -> InvalidDataReceived
// if promoId is not allowed for that user  -> Forbbiden Exception
// if everything goes well                  -> return

describe('Authorization', function() {
  describe('isAuthorized()', function() {

    before(async function() {
      var promoStatIDontOwn = {};
      promoStatIDontOwn.promotion_definition_id = 99999;
	    promoStatIDontOwn.code = "ZZZZZZZZ";
	    promoStatIDontOwn.successful = true;
	    promoStatIDontOwn.response_time = 100;
      promoStatIDontOwn.spent_amount = 1000;
      await promoStatLogic.processStatistic(promoStatIDontOwn);

      var promoStatIOwn = {};
      promoStatIOwn.promotion_definition_id = 1000000;
	    promoStatIOwn.code = "MnIrd1Gk";
	    promoStatIOwn.successful = true;
	    promoStatIOwn.response_time = 200;
      promoStatIOwn.spent_amount = 2000;
      await promoStatLogic.processStatistic(promoStatIOwn);
    });
  
    after(async function() {
      await promoStatLogic.deletePromoStatisticsByPromoId(99999);
      await promoStatLogic.deletePromoStatisticsByPromoId(1000000);
    });

    it('should throw an InvalidCredentials exception when the token is not present', async function() {
      try {
        await authLogic.isAuthorized(null, 1000);
        assert.fail('expected exception not thrown'); 
      } catch (ex) { 
        if (ex.name !== e.InvalidCredentials) {
          assert.fail('not the expected exception');
        }
      }
    });

    it('should throw an InvalidCredentials exception when the token is not valid', async function() {
      try {
        await authLogic.isAuthorized(tokenInvalid, 1000);
        assert.fail('expected exception not thrown'); 
      } catch (ex) { 
        if (ex.name !== e.InvalidCredentials) {
          assert.fail('not the expected exception');
        }
      }
    });

    it('should throw a InvalidDataReceived exception when the promoId does not exists', async function() {
      try {
        await authLogic.isAuthorized(tokenValid, 99998);
        assert.fail('expected exception not thrown'); 
      } catch (ex) { 
        if (ex.name !== e.InvalidDataReceived) {
          assert.fail('not the expected exception');
        }
      }
    });

    it('should throw a Forbbiden exception when the promoId is not allowed for that user', async function() {
      try {
        await authLogic.isAuthorized(tokenValid, 99999);
        assert.fail('expected exception not thrown'); 
      } catch (ex) { 
        if (ex.name !== e.Forbidden) {
          assert.fail('not the expected exception');
        }
      }
    });
    
    it('should authorize when everything goes well', async function() {
      try {
        await authLogic.isAuthorized(tokenValid, 1000000);
      } catch (ex) { 
        console.log(ex);
        assert.fail('exception not expected');
      }
    });

  });
});

// if promoId does not exists    -> returns empty summary
// if promoId exists             -> returns loaded summary and data validates ok

describe('Statistics Summary', function() {
  describe('getPromoStatsSummary()', function() {

    before(async function() { 
      var promoStat1 = {};
      promoStat1.promotion_definition_id = 1000001;
	    promoStat1.code = "2ZUdOleD";
	    promoStat1.successful = true;
	    promoStat1.response_time = 100;
      promoStat1.spent_amount = 1000;
      await promoStatLogic.processStatistic(promoStat1);

      var promoStat2 = {};
      promoStat2.promotion_definition_id = 1000001;
	    promoStat2.code = "2ZUdOleD";
	    promoStat2.successful = true;
	    promoStat2.response_time = 200;
      promoStat2.spent_amount = 2000;
      await promoStatLogic.processStatistic(promoStat2);
      
      var promoStat3 = {};
      promoStat3.promotion_definition_id = 1000001;
	    promoStat3.code = "2ZUdOleD";
	    promoStat3.successful = false;
	    promoStat3.response_time = 300;
      promoStat3.spent_amount = 3000;
      await promoStatLogic.processStatistic(promoStat3);

      var promoStat4 = {};
      promoStat4.promotion_definition_id = 1000001;
	    promoStat4.code = "2ZUdOleD";
	    promoStat4.successful = true;
	    promoStat4.response_time = 400;
      promoStat4.spent_amount = 4000;
      await promoStatLogic.processStatistic(promoStat4);
    });
  
    after(async function() {
      await promoStatLogic.deletePromoStatisticsByPromoId(1000001);
      await promoStatLogic.deletePromoStatisticsByPromoId(1000001);
      await promoStatLogic.deletePromoStatisticsByPromoId(1000001);
      await promoStatLogic.deletePromoStatisticsByPromoId(1000001);
    });

    it('should return an empty summary when the promoId does not exists', async function() {
      
      var emptySummary = {};
      emptySummary.total_calls = 0;
      emptySummary.successful = 0;
      emptySummary.unsuccessful = 0;
      emptySummary.successful_ratio = 0;
      emptySummary.average_response_time = 0;
      emptySummary.total_spent = 0;
      
      var ret = await promoStatLogic.getPromoStatsSummary(200000);
      assert.equal(JSON.stringify(ret), JSON.stringify(emptySummary)); 
    });

    it('should return loaded summary and data validates ok', async function() {
      
      var summary_ok = {};
      summary_ok.total_calls = 4;
      summary_ok.successful = 3;
      summary_ok.unsuccessful = 1;
      summary_ok.successful_ratio = 75;
      summary_ok.average_response_time = 250;
      summary_ok.total_spent = 7000;
      
      var ret = await promoStatLogic.getPromoStatsSummary(1000001);
      assert.equal(JSON.stringify(ret), JSON.stringify(summary_ok)); 
    });

  });
});

// if promoId does not exists                         ->  returns {count: 0}
// if promoId exists and receive unspecified filter   ->  returns {count: total promo request}
// if promoId exists and receive country filter       ->  returns {count: total promo request for that country}
// if promoId exists and receive city filter          ->  returns {count: total promo request for that city}
// if promoId exists and receive age range filter     ->  returns {count: total promo request for that age range}

describe('Demographic Report', function() {
  describe('getPromoStatsDemographic()', function() {

    before(async function() { 
      var promoStat1 = {};
      promoStat1.promotion_definition_id = 1000010;
	    promoStat1.code = "2ZUdOleD";
	    promoStat1.successful = true;
	    promoStat1.response_time = 100;
      promoStat1.spent_amount = 1000;
      promoStat1.country = "UY";
      promoStat1.city = "MVD";
      promoStat1.age = 18;
      await promoStatLogic.processStatistic(promoStat1);

      var promoStat2 = {};
      promoStat2.promotion_definition_id = 1000010;
	    promoStat2.code = "2ZUdOleD";
	    promoStat2.successful = true;
	    promoStat2.response_time = 200;
      promoStat2.spent_amount = 2000;
      promoStat2.country = "UY";
      promoStat2.city = "MVD";
      promoStat2.age = 30;
      await promoStatLogic.processStatistic(promoStat2);
      
      var promoStat3 = {};
      promoStat3.promotion_definition_id = 1000010;
	    promoStat3.code = "2ZUdOleD";
	    promoStat3.successful = false;
	    promoStat3.response_time = 300;
      promoStat3.spent_amount = 3000;
      promoStat3.country = "US";
      promoStat3.city = "WAS";
      promoStat3.age = 35;
      await promoStatLogic.processStatistic(promoStat3);

      var promoStat4 = {};
      promoStat4.promotion_definition_id = 1000010;
	    promoStat4.code = "2ZUdOleD";
	    promoStat4.successful = true;
	    promoStat4.response_time = 400;
      promoStat4.spent_amount = 4000;
      promoStat4.country = "ES";
      promoStat4.city = "MAD";
      promoStat4.age = 50;
      await promoStatLogic.processStatistic(promoStat4);

      var promoStat5 = {};
      promoStat5.promotion_definition_id = 1000010;
	    promoStat5.code = "2ZUdOleD";
	    promoStat5.successful = true;
	    promoStat5.response_time = 400;
      promoStat5.spent_amount = 4000;
      promoStat5.country = "UY";
      promoStat5.city = "MVD";
      promoStat5.age = 70;
      await promoStatLogic.processStatistic(promoStat5);
    });
  
    after(async function() {
      await promoStatLogic.deletePromoStatisticsByPromoId(1000010);
      await promoStatLogic.deletePromoStatisticsByPromoId(1000010);
      await promoStatLogic.deletePromoStatisticsByPromoId(1000010);
      await promoStatLogic.deletePromoStatisticsByPromoId(1000010);
      await promoStatLogic.deletePromoStatisticsByPromoId(1000010);
    });

    it('should return {count: 0} when the promoId does not exists', async function() {
      
      var expectedResp = {};
      expectedResp.count = 0;

      var queryFilter = {};
      queryFilter.country = '';
      queryFilter.city = '';
      queryFilter.age = ''; 
    
      var ret = await promoStatLogic.getPromoStatsDemographic(200000, queryFilter);
      assert.equal(JSON.stringify(ret), JSON.stringify(expectedResp)); 
    });
  
    it('should return {count: total promo requests} when the promoId exists and receive unspecified filter', async function() {
      
      var expectedResp = {};
      expectedResp.count = 5;

      var queryFilter = {};
      queryFilter.country = '';
      queryFilter.city = '';
      queryFilter.age = ''; 
    
      var ret = await promoStatLogic.getPromoStatsDemographic(1000010, queryFilter);
      assert.equal(JSON.stringify(ret), JSON.stringify(expectedResp)); 
      
    });
  
    it('should return {count: total promo requests for that country} when the promoId exists and receive country filter', async function() {
      
      var expectedResp = {};
      expectedResp.count = 3;

      var queryFilter = {};
      queryFilter.country = 'UY';
      queryFilter.city = '';
      queryFilter.age = ''; 
    
      var ret = await promoStatLogic.getPromoStatsDemographic(1000010, queryFilter);
      assert.equal(JSON.stringify(ret), JSON.stringify(expectedResp)); 
      
    });

    it('should return {count: total promo requests for that city} when the promoId exists and receive city filter', async function() {
      
      var expectedResp = {};
      expectedResp.count = 1;

      var queryFilter = {};
      queryFilter.country = '';
      queryFilter.city = 'MAD';
      queryFilter.age = ''; 
    
      var ret = await promoStatLogic.getPromoStatsDemographic(1000010, queryFilter);
      assert.equal(JSON.stringify(ret), JSON.stringify(expectedResp)); 
      
    });

    it('should return {count: total promo requests for that age range} when the promoId exists and receive an age range filter', async function() {
      
      var expectedResp = {};
      expectedResp.count = 2;

      var queryFilter = {};
      queryFilter.country = '';
      queryFilter.city = '';
      queryFilter.age = '25-40'; 
    
      var ret = await promoStatLogic.getPromoStatsDemographic(1000010, queryFilter);
      assert.equal(JSON.stringify(ret), JSON.stringify(expectedResp)); 
      
    });

    it('should return {count: total promo requests for that complete filter} when the promoId exists and receive country, city and an age range filter', async function() {
      
      var expectedResp = {};
      expectedResp.count = 1;

      var queryFilter = {};
      queryFilter.country = 'US';
      queryFilter.city = 'WAS';
      queryFilter.age = '25-40'; 
    
      var ret = await promoStatLogic.getPromoStatsDemographic(1000010, queryFilter);
      assert.equal(JSON.stringify(ret), JSON.stringify(expectedResp)); 
      
    });

  });
});
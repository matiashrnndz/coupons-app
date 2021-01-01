const promoStatDA = require('../data_access/promo_stats.da');
const validatorPromoStat = require('./validators/promo_stat.validator');
const validatorNumID = require('./validators/numeric-id.validator');
const validatorFilter = require('./validators/filter.validator');
const e = require('../exceptions/exceptions');
const moment = require('moment');

async function processStatistic(newStat){ 
    await validatorPromoStat.isValidPromoStat(newStat);

    if (moment(newStat.birth_date, 'MM/DD/YYYY', true).isValid()){
        
        var monthAux = newStat.birth_date.substring(0, 2);
        var dayAux = newStat.birth_date.substring(3, 5);
        var yearAux = newStat.birth_date.substring(6, 10);

        var ageAux = calculate_age(new Date(yearAux, monthAux, dayAux));
        newStat.age = ageAux;
    }

    const createdPromoStat = await promoStatDA.addStatistic(newStat);

    if(!createdPromoStat)
        throw {name : e.DataBaseError, message: 'Unable to create Promo Stat.'};
    return createdPromoStat;
};

function calculate_age(dob) { 
    var diff_ms = Date.now() - dob.getTime();
    var age_dt = new Date(diff_ms); 
  
    return Math.abs(age_dt.getUTCFullYear() - 1970);
}

async function getAllPromoStatistics(){ 
    const query = {};
    promosStats = await promoStatDA.getPromosStats(query);
    return promosStats;
};

async function getPromoStatisticsByPromoId(promoId){ 
    await validatorNumID.isValidID(promoId);
    const query = {"promotion_definition_id":promoId};
    promoStats = await promoStatDA.getPromosStats(query);
    return promoStats;
};

async function getEmptySummary(){
    var summary = {};
    summary.total_calls = 0;
    summary.successful = 0;
    summary.unsuccessful = 0;
    summary.successful_ratio = 0;
    summary.average_response_time = 0;
    summary.total_spent = 0;
    return summary;
}

async function computeSummary(total, totalSuccess, totalSpent, totalRespTime){
    var summary = {};
    summary.total_calls = total;
    summary.successful = totalSuccess;
    summary.unsuccessful = total - totalSuccess;
    summary.successful_ratio = total != 0 ? (totalSuccess * 100)/total : 0;
    summary.average_response_time = total != 0 ? totalRespTime/total : 0;
    summary.total_spent = totalSpent;
    return summary;
}

async function getSummaryLoaded(promoStats){
    var total = 0; totalSuccess = 0; totalSpent = 0; totalRespTime = 0;
    total = promoStats.length;    
    for(i in promoStats){
        statAux = promoStats[i];
        if(statAux.successful === true){
            totalSuccess++;
            totalSpent += statAux.spent_amount;
        }
        totalRespTime += statAux.response_time;
    }
    return computeSummary(total, totalSuccess, totalSpent, totalRespTime);
}

async function getPromoStatsSummary(promoId){ 
    await validatorNumID.isValidID(promoId);
    const query = {"promotion_definition_id":promoId};
    promoStats = await promoStatDA.getPromosStats(query);
    var summary;

    if(promoStats.length > 0){
        summary = await getSummaryLoaded(promoStats);
    }else{
        summary = await getEmptySummary();
    }
    return summary;
};

async function deletePromoStatisticsByPromoId(promoId){ 
    await validatorNumID.isValidID(promoId);
    const query = {"promotion_definition_id":promoId};
    promoStats = await promoStatDA.deletePromoStat(query);
    return promoStats;
};

async function getPromoStatsDemographic(promoId, queryFilter){    
    await validatorNumID.isValidID(promoId);
    await validatorFilter.isValidFilter(queryFilter);

    const query = {};
    var minInRange;
    var maxInRange;
    query.promotion_definition_id = promoId;

    if(queryFilter.country){
        query.country = queryFilter.country.toUpperCase();
    }
    if(queryFilter.city){
        query.city = queryFilter.city.toUpperCase();
    }
    if(queryFilter.age){
        if (queryFilter.age === '18-25' ||
            queryFilter.age === '25-40' ||
            queryFilter.age === '40-60') {
            minInRange = queryFilter.age.substring(0, 2);
            maxInRange = queryFilter.age.substring(3, 5);        
            query.age = { $gte:  minInRange , $lte: maxInRange };
            
        }else if(queryFilter.age === '60+' ||
                 queryFilter.age === '60 '){
            minInRange = queryFilter.age.substring(0, 2);
            query.age = { $gt: minInRange };
        }        
    }

    promoStats = await promoStatDA.getPromosStats(query);
    return {'count': promoStats.length};
}

module.exports.processStatistic = processStatistic;
module.exports.getAllPromoStatistics = getAllPromoStatistics;
module.exports.getPromoStatisticsByPromoId = getPromoStatisticsByPromoId;
module.exports.getPromoStatsSummary = getPromoStatsSummary;
module.exports.deletePromoStatisticsByPromoId = deletePromoStatisticsByPromoId;
module.exports.getPromoStatsDemographic = getPromoStatsDemographic;
const PromoStatistic = require('./models/promo_stat.model');

async function addStatistic(newStat){ 
    return new Promise((resolve, reject) => {
        PromoStatistic.insertMany([newStat], function (err, createdstat) {
            if (err) {
                console.log('error ' + err);
            }
            resolve(createdstat);
        })
    });
};

async function getPromosStats(filter){ 
    return new Promise((resolve, reject) => {
        PromoStatistic.find(filter, function (err, promosStats) {
            if (err) {
                console.log('error ' + err);
            }
            resolve(promosStats);
        })
    });
};

async function getPromoStat(filter){ 
    return new Promise((resolve, reject) => {
        PromoStatistic.findOne(filter, function (err, promosStat) {
            if (err) {
                console.log('error ' + err);
            }
            resolve(promosStat);
        })
    });
};

async function deletePromoStat(filter){ 
    return new Promise((resolve, reject) => {
        PromoStatistic.findOneAndDelete(filter, function (err, promosStat) {
            if (err) {
                console.log('error ' + err);
            }
            resolve(promosStat);
        })
    });
};

module.exports.addStatistic = addStatistic;
module.exports.getPromosStats = getPromosStats;
module.exports.getPromoStat = getPromoStat;
module.exports.deletePromoStat = deletePromoStat;

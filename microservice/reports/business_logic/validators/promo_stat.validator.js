const e = require('../../exceptions/exceptions');

async function isValidPromoStat(promoStat) {

    if (!promoStat) 
        throw { name : e.InvalidDataReceived, message: "Invalid Promo Stat" };
    
    if (!promoStat.promotion_definition_id
        || promoStat.promotion_definition_id === null 
        || isNaN(promoStat.promotion_definition_id)) {
            throw { name : e.InvalidDataReceived, message: "Invalid PromoStat.promotion_definition_id" };
    }

    if (!promoStat.code
        || promoStat.code === null 
        || promoStat.code.length != 8) {
            throw { name : e.InvalidDataReceived, message: "Invalid PromoStat.code" };
    }

    if (promoStat.successful === null 
        || (promoStat.successful !== true && promoStat.successful !== false)) {
            throw { name : e.InvalidDataReceived, message: "Invalid PromoStat.successful" };
    }

    if (promoStat.response_time === null 
        || isNaN(promoStat.response_time)) {
            throw { name : e.InvalidDataReceived, message: "Invalid PromoStat.response_time" };
    }

    if (promoStat.spent_amount === null 
        || isNaN(promoStat.spent_amount)) {
            throw { name : e.InvalidDataReceived, message: "Invalid PromoStat.spent_amount" };
    }

    return;
}

module.exports.isValidPromoStat = isValidPromoStat;
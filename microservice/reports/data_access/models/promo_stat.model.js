const mongoose = require('mongoose');
const Schema = mongoose.Schema;

let PromoStatSchema = new Schema({

    promotion_definition_id: {type: Number, required: true},
    code: {type: String, required: true, min: 8, max: 8},
    successful: {type: Boolean, required: true},
    response_time: {type: Number, required: true}, 
    spent_amount: {type: Number, required: true},
    country: {type: String},
    city: {type: String},
    birth_date: {type: String},
    age: {type: Number}
});

module.exports = mongoose.model('PromoStatistic', PromoStatSchema);
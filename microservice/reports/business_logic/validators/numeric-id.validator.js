const e = require('../../exceptions/exceptions');

async function isValidID(id) {

    if (id === null
        || isNaN(id)) { 
            throw { name : e.InvalidDataReceived, message: "Invalid ID received." };
    }
    
    return;
}

module.exports.isValidID = isValidID;
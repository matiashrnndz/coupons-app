const e = require('../../exceptions/exceptions');
const { getCode, getName } = require('country-list');
const airports = require('airport-codes');

async function isValidFilter(queryFilter) {
    
    if (!queryFilter) 
      throw { name : e.InvalidDataReceived, message: "Invalid Filter" };
    
    if(queryFilter.country){
      if (queryFilter.country === null ||
          queryFilter.country.length != 2) {
            throw { name : e.InvalidDataReceived, message: "Invalid Filter.country (ISO3166-1 2 bytes length expected)" };
      }else{

        if(!getName(queryFilter.country.toUpperCase())){
          throw { name : e.InvalidDataReceived, message: "Invalid ISO3166-1 code in Filter.country" };
        }

        //console.log(getName(queryFilter.country)); 
      } 
    }
    
    if(queryFilter.city){
      if (queryFilter.city === null ||
          queryFilter.city.length != 3) {
            throw { name : e.InvalidDataReceived, message: "Invalid Filter.city (IATA 3 bytes length expected)" };
      }else{

        var cityAux = airports.findWhere({ iata: queryFilter.city.toUpperCase() });

        if(!cityAux){
          throw { name : e.InvalidDataReceived, message: "Invalid IATA code in Filter.city" };
        }

        //console.log(airports.findWhere({ iata: queryFilter.city }).get('name'));
      } 
    }

    return;
}

module.exports.isValidFilter = isValidFilter;
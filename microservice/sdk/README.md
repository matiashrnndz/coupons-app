# Coupons App  |  SDK

<p align="center">
  <img src="https://m.media-amazon.com/images/G/01/mobile-apps/dex/alexa/alexa-voice-service/sdk/SDK-page-art-2x._CB505259190_.png" width="350">
</p>

This library was developed to help programmers to use the COUPONS evaluation service in an easy and intuitive way.


## Framework and language

- ***Node.js***: s an open-source, cross-platform, JavaScript runtime environment that executes JavaScript code outside of a browser. Node.js lets developers use JavaScript to write command line tools and for server-side scripting—running scripts server-side to produce dynamic web page content before the page is sent to the user's web browser. Consequently, Node.js represents a "JavaScript everywhere" paradigm, unifying web-application development around a single programming language, rather than different languages for server- and client-side scripts.

- ***Javascript***: is a high-level, interpreted scripting language that conforms to the ECMAScript specification. JavaScript has curly-bracket syntax, dynamic typing, prototype-based object-orientation, and first-class functions.

## External system dependencies

- ***request***: is designed to be the simplest way possible to make http calls. It supports HTTPS and follows redirects by default.

## Development instructions

- Download repository

```bash
$ git clone https://github.com/ArqSoftPractica/ASP_Obl_SDK.git
```

- Install dependencies

```bash
$ npm install
```
  
- Examine and modify the code as you want

## Usage

### Install

- Install Coupons SDK in your app directory and save it in the dependencies list. 

```bash
$ npm install coupons-sdk --save
```

- Your app package.json should look like this

```json
...
"dependencies": {
    "coupons-sdk": "^1.1.0"
  }
```
- This is the easiest way to include the SDK module to your project

```javascript
const couponsSDK = require('coupons-sdk');
```

### Request evaluation

- You can use the library through one of the two methods that it provides 

```javascript
resp = await couponsSDK.requestEvaluationJsonFormat(dataToEval);
```
*dataToEval* format example:
```json
{ 
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJjb2RlcyI6WyJNbklyZDFHayJdLCJuMTU3NDYwNDU2Nn0.vAosSo9iA0J6a62vssMcHH23Xav3iKRLI",
  "code": "MnIrd1Gk",
  "metadata": { 
      "total": "1000",
      "country": "UY",
      "city": "MVD",
      "birth_date": "07/18/1977",
      "coupon_code": "GPJFUrkn",
      "attributes": { 
          "volumen": "50", 
          "peso": "60" 
     	} 
   } 
}
```

```javascript
resp = await couponsSDK.requestEvaluationSeveralParamsFormat(token, promo_code, total, promo_type, txnid_or_couponcode, attr_list, country='', city='', birthday='');
```
Params format example:

```javascript
token = "eyJhbGciOiJIUzI1NiJ9.eyJjb2RlcyI6WyJNbklyZDFHayJdLCJuMTU3NDYwNDU2Nn0.vAosSo9iA0J6a62vssMcHH23Xav3iKRLI";
promo_code = "MnIrd1Gk";
total = "1000";
promo_type = "coupon"; //or "discount"
txnid_or_couponcode = "GPJFUrkn";
attr_list = "{'volumen': '50', 'peso': '60'}"
country = "UY" //optional
city = "MVD" //optional
birthday = "07/18/1977" //optional, format: (MM/DD/YYYY)
```

## Simple and functional client provided

In the following link you will find a client that you can use to try our COUPONS evaluation service. It use this SDK implementation (obviously! :blush:).

- [Coupons SDK Client](https://github.com/ArqSoftPractica/ASP_Obl_ClientSDK) 		


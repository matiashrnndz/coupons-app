# Coupons App  |  Microservice for Reporting

<p align="center">
  <img src="https://sab99r.com/wp-content/uploads/2017/01/nodejs-mongodb-heroku.png" width="350">
</p>

## Framework and language

- ***Node.js***: s an open-source, cross-platform, JavaScript runtime environment that executes JavaScript code outside of a browser. Node.js lets developers use JavaScript to write command line tools and for server-side scripting—running scripts server-side to produce dynamic web page content before the page is sent to the user's web browser. Consequently, Node.js represents a "JavaScript everywhere" paradigm, unifying web-application development around a single programming language, rather than different languages for server- and client-side scripts.

- ***Express.js***:  is a web application framework for Node.js, released as free and open-source software under the MIT License. It is designed for building web applications and APIs. It has been called the de facto standard server framework for Node.js

- ***Javascript***: is a high-level, interpreted scripting language that conforms to the ECMAScript specification. JavaScript has curly-bracket syntax, dynamic typing, prototype-based object-orientation, and first-class functions.

## External system dependencies

- ***body-parser***: parse incoming request bodies in a middleware before your handlers, available under the req.body property.

- ***dotenv***: module that loads environment variables from a .env file into process.env. Storing configuration in the environment separate from code is based on The Twelve-Factor App methodology.

- ***express***: fast, unopinionated, minimalist web framework for node.

- ***jsonwebtoken***: an implementation of JSON Web Tokens.

- ***mongoose***: is a MongoDB object modeling tool designed to work in an asynchronous environment. 

- ***request***: is designed to be the simplest way possible to make http calls. It supports HTTPS and follows redirects by default.

- ***amqplib***: AMQP clients for Node.js, which is an open, general-purpose protocol for messaging. Used to speak with RabbitMQ.

- ***mocha***: Mocha is a feature-rich JavaScript test framework running on Node.js, making asynchronous testing simple 

- ***moment***: parse, validate, manipulate, and display dates and times in JavaScript.

- ***lightstep-tracer***: distributed tracing library for Node.js and the browser.

- ***opentracing***: this library is a JavaScript implementation of Open Tracing API.

- ***country-list***: maps ISO 3166-1-alpha-2 codes to English country names and vice versa.

- ***airport-codes***: list of IATA codes that is wrapped in a Backbone Collection, so have access to all normal collection methods like findWhere, at, and sort

## Development instructions

- Download repository

```bash
$ git clone https://github.com/ArqSoftPractica/ASP_Obl_Reports.git
```

- Install dependencies

```bash
$ npm install
```
+ Dotenv configuration

  * Create **.env** file into the project root folder
  * Create key **DB_URL**=...(get it from heroku config vars)
  * Create key **SECRET_KEY_BASE**=...(get it from heroku config vars)
  
- Run the application
```bash
$ npm start
```

## Endpoints
  
- For production purpose (JWT is required)  
  
  - [GET]  https://app-coupons-reports.herokuapp.com/api/promo_stats/{:id}/summary
  - [GET]  https://app-coupons-reports.herokuapp.com/api/promo_stats/{:id}/demographic?country=UY&city=MVD&age=40-60
  
> note: the user agent should send the JWT in the Authorization header, {:id} is the PromoDefinition identification, and in the second endpoint the query parameters are all optionals, *country* must be in 3166-1-alpha-2 format, and *city* must be in IATA format.

+ Just for development purpose (JWT not required)

  * [GET]  https://app-coupons-reports.herokuapp.com/api/promo_stats
  
  * [GET]  https://app-coupons-reports.herokuapp.com/api/promo_stats/{:id}

  * [POST]  https://app-coupons-reports.herokuapp.com/api/promo_stats/
  
 ```json
 {
     "promotion_definition_id": 1,
     "code": "ABCDEFGH",
     "successful": true,
     "response_time": 100,
     "spent_amount": 2000
 }
 ```  

## Storage

We decided to use MongoDB for storage purposes, so the data is stored in the form of JSON style documents. To simplify working with MongoDB, we created an account in [mLab](https://mlab.com), which is a hosting service for MongoDB.

Once you create an account, you will find the connection string on mLab on the home dashboard under MongoDB Deployments.

```url
mongodb://<dbuser>:<dbpassword>@ds157571.mlab.com:57571/db_name
```
> note: this connection string is protected by Dotenv so it is never pushed to this GitHub repo. If you try to deploy this application, you must set the connection string as a configuration variable called **DB URL** in your desired cloud service

We've used an object document mapper (ODM). The officially supported ODM for MongoDB is Mongoose. Mongoose introduces schemas and models, which are similar to classes in traditional object-oriented-programming.



## Unit Testing with Mocha

- Install *Mocha* with npm

```bash
$ npm install --save mocha
```

- Create a Test folder into the project root folder and create a new JavaScript test file in it

```bash
$ mkdir test
$ cd test
$ touch test.js
```

- Edit the test.js file with your preferred editor and write a simple test case to verify that everything is configured correctly

```javascript
var assert = require('assert');
describe('Array', function() {
  describe('#indexOf()', function() {
    it('should return -1 when the value is not present', function() {
      assert.equal([1, 2, 3].indexOf(4), -1);
    });
  });
});
```

- Set up a test script in package.json

```json
"scripts": {
  "test": "mocha"
}
```

- Then run tests with
```bash
$ npm test
```

- The output will look something like this
```bash
Array
    #indexOf()
      ✓ should return -1 when the value is not present


  1 passing (9ms)
```

# Coupons App  |  SDK Client

## Framework and language

- ***Node.js***: s an open-source, cross-platform, JavaScript runtime environment that executes JavaScript code outside of a browser. Node.js lets developers use JavaScript to write command line tools and for server-side scripting—running scripts server-side to produce dynamic web page content before the page is sent to the user's web browser. Consequently, Node.js represents a "JavaScript everywhere" paradigm, unifying web-application development around a single programming language, rather than different languages for server- and client-side scripts.

- ***Express.js***:  is a web application framework for Node.js, released as free and open-source software under the MIT License. It is designed for building web applications and APIs. It has been called the de facto standard server framework for Node.js

- ***Javascript***: is a high-level, interpreted scripting language that conforms to the ECMAScript specification. JavaScript has curly-bracket syntax, dynamic typing, prototype-based object-orientation, and first-class functions.

## External system dependencies

- ***body-parser***: parse incoming request bodies in a middleware before your handlers, available under the req.body property.

- ***express***: fast, unopinionated, minimalist web framework for node.

- ***coupons-sdk***: library that helps programmers to use the COUPONS evaluation service in an easy and intuitive way.

## Development instructions

- Download repository

```bash
$ git clone https://github.com/ArqSoftPractica/ASP_Obl_ClientSDK.git
```

- Install dependencies

```bash
$ npm install
```
  
- Run the application
```bash
$ npm start
```

- Visualize client web page (in your preferred browser)

   http://localhost:3001

## Endpoints
  
- This client provides two endpoints
  
  - [GET]  http://localhost:3001/
  - [POST] http://localhost:3001/process

The first endpoint (**/**) is reached by default when entering the main url, this endpoint delivers the html view to the    browser so that the user can enter the data in a web form.

The second endpoint (**/process**) is in charge of processing the form data and then send it to the Coupons evaluation service for approval.

## Try it now!

- This client is already upload to the cloud for you, you can try it by clicking on the following link

  https://app-coupons-client.herokuapp.com/


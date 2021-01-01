# coupons-app (microservices example)

[Project done on Nov 2019.]

Coupons is a microservice example that shows the transformation from a basic monolith to a basic microservice app.
On every app contained you will find a readme that explains it.

## Purpose

Develop concepts that define cloud computing by adopting software construction techniques as a service, from development to deployment in a production environment.

## Scope

Coupons is based on the creation, management and traceability of promotional coupons and discounts.
They can be managed from the same place. That is, given a coupon that a company is offering, the system must validate if the coupon is valid and if it also complies with the rules to be applied.

## Monolith

The first project is a monolith app that is a basic coupons app.

- Backend is developed in Ruby.

## Microservice

The second project is composed from various apps that forms an extended coupons app.

- 'backend' is developed in Ruby and contains the main functions of the coupon app.

- 'ui' is developed in Ruby and contains a web interface for the coupon app.

- 'sdk' is developed in Node.js.
This library was developed to help programmers to use the COUPONS evaluation service in an easy and intuitive way.

- 'reports' is developed in Node.js and its an api that serves as a report system that can be consumed from other services.

- 'client-sdk' is developed in Node.js and it is the client needed to use the sdk.

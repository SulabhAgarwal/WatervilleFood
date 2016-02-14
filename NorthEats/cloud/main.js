/* Initialize the Stripe and Mailgun Cloud Modules */
var Stripe = require('stripe');
Stripe.initialize('sk_test_XfTC9p5m97fDNc5SHXWtjVAy');
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("purchase", function(request, response) {
   Stripe.Charges.create({
      amount: request.params.amount * 100, 
      currency: "usd",
      card: request.params.stripeToken // the token id should be sent from the client
      },{
      success: function(httpResponse) {
      response.success("Purchase made!");
      },
      error: function(httpResponse) {
      response.error("Uh oh, something went wrong");
      response.error(httpResponse.message);
      // alternatively
      console.log(httpResponse.message);
      }
      });
});
// Generated by CoffeeScript 1.6.2
/*
  Show example usage with static test data
*/


(function() {
  var payjaq, test;

  payjaq = require("./payjaq");

  /*
    Exercise the functions in payjaq
  */


  test = function() {
    var client_id, client_secret;

    console.log("Run usage examples");
    client_id = 'EOJ2S-Z6OoN_le_KS1d75wsZ6y0SFdVsY9183IvxFyZp';
    client_secret = 'EClusMEUk8e9ihI7ZdVLF5cZ6y0SFdVsY9183IvxFyZp';
    /*
      Get a token that will be used to credential the remaining ops
    */

    return payjaq.getToken(client_id, client_secret, function(res) {
      var test_payment, token;

      token = res.access_token;
      console.log(" ");
      /*
        Get 10 payments
      */

      payjaq.getPaymentsPaged(token, function(res) {
        var fakeid;

        console.log(" ");
        /*
          Get a payment by id
        */

        fakeid = res.payments[0].id;
        payjaq.getPaymentById(fakeid, token);
        return console.log(" ");
      });
      /*
        Get your payments of status approved
      */

      payjaq.getApprovedPayments(token);
      console.log(" ");
      /*
        Make a test object
      */

      test_payment = {
        intent: "sale",
        payer: {
          payment_method: "credit_card",
          funding_instruments: [
            {
              credit_card: {
                number: "4417119669820331",
                type: "visa",
                expire_month: 11,
                expire_year: 2018,
                cvv2: 874,
                first_name: "Joe",
                last_name: "Shopper",
                billing_address: {
                  line1: "52 N Main ST",
                  city: "Johnstown",
                  country_code: "US",
                  postal_code: "43210",
                  state: "OH"
                }
              }
            }
          ]
        },
        transactions: [
          {
            amount: {
              total: "7.47",
              currency: "USD",
              details: {
                subtotal: "7.41",
                tax: "0.03",
                shipping: "0.03"
              }
            },
            description: "This is the FAKE transaction description."
          }
        ]
      };
      /*
        Create a payment with the test object
      */

      payjaq.createPayment(test_payment, token, function(res) {
        var payer;

        console.log("created payment.id == ", res.id);
        console.log(" ");
        /*
          Executing that payment will fail as is
        */

        console.log("Note: EXPECTED to ERROR: PAYMENT_STATE_INVALID until");
        console.log("you get your own PayPal sandbox account for live objects.");
        payer = {
          payer_id: "7E7MGXCWTTKK2"
        };
        return payjaq.executePayment(res.id, payer, token, function(res) {
          return console.log("EXECUTE result: ", res);
        });
      });
      return console.log(" ");
    });
  };

  test();

}).call(this);

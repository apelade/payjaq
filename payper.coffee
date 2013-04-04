###
# payper
======

## Node Examples for the _PayPal_ REST API with AJAX


## Featuring [SuperAgent](https://github.com/visionmedia/superagent) for nice the AJAX
See the PayPal API at: https://developer.paypal.com/webapps/developer/docs/api


## Install:
- Run the [nodejs.org](http://nodejs.org) installer.
- Download the [zip file](https://github.com/apelade/payper/archive/master.zip).
- Extract it and open a shell there.
- `npm install superagent`
- `npm install -g coffee-script` if desired?


## Run:
- `node payper.js` or `coffee payper.coffee`
- `coffee -c payper.coffee` compiles coffee to javascript


## Notes: 
- The tests that try to execute a payment Correctly Fail with PAYMENT_STATE_INVALID 
  when running static PayPal test objects.
- To create live test objects, get a dev client id and secret from PayPal.
- Note the payment approval step must have been taken by the user for
  completePayment to succeed.
- Don't forget to redirect to approval_url listed in response links if using
  the paypal payment method.
- Since this is an example, uses a single-arg callback.
- Otherwise, it may be a callback per result state, using a common err handler.
###

superagent = require 'superagent'

printResults = (err, res) ->
  console.log err if err?
  console.log res.body if res?.body?
  console.log  ' '
  
PAYMENT = 'https://api.sandbox.paypal.com/v1/payments/payment/'

## Three wrapper functions for each main ajax type we need. No beforeSend func!

ajaxGet = (extraPath, token, callback) ->
  superagent.agent()
  .get(PAYMENT + extraPath)
  .set('Content-Type', 'application/json')
  .set('Authorization','Bearer ' + token)
  .end(callback)

ajaxPost = (path, data, token, callback) ->
  superagent.agent()
  .post(PAYMENT + path)
  .type('application/x-www-form-urlencoded')
  .send(data)
  .set('Content-Type', 'application/json')
  .set('Authorization','Bearer ' + token)
  .end(callback)
  
module.exports.getToken = ( username, password, callback = printResults ) ->
  client_id = username
  client_secret = password
  basicAuthCred = client_id + ":" + client_secret + "@"
  url = "https://" + basicAuthCred + "api.sandbox.paypal.com/v1/oauth2/token"
  data = { grant_type : 'client_credentials' }
  superagent.agent()
  .post(url)
  .type('application/x-www-form-urlencoded')
  .send(data)
  .set('Accept', 'application/json')
  .set('Accept-Language', 'en_US')
  .end(callback)


## These would be called from routes in Express server

module.exports.getAllPayments = ( token, callback = printResults) ->
  ajaxGet("", token, callback)

  
module.exports.getApprovedPayments = ( token, callback = printResults ) ->
  ajaxGet('?state=approved', token, callback)

  
module.exports.getPaymentsPaged = ( token, callback = printResults ) ->
  ajaxGet('?count=10', token, callback)


module.exports.getPaymentById = ( id, token, callback = printResults ) ->
  ajaxGet(id, token, callback)
 
 
module.exports.createPayment = ( payment, token, callback = printResults ) ->
  ajaxPost("", JSON.stringify(payment), token, callback)


module.exports.executePayment = ( id, payer, token, callback = printResults ) ->
  ajaxPost( id + '/execute/', JSON.stringify(payer), token, callback)


## Show example usage with static test data

module.exports.test = () ->
  client_id = 'EOJ2S-Z6OoN_le_KS1d75wsZ6y0SFdVsY9183IvxFyZp'
  client_secret = 'EClusMEUk8e9ihI7ZdVLF5cZ6y0SFdVsY9183IvxFyZp'
  module.exports.getToken client_id, client_secret, (err, res) ->
    console.log err if err? 
    token = res.body.access_token
    console.log "Token == ", token, "\n"
    module.exports.getPaymentsPaged token, (err, res) ->
      console.log " "
      console.log res.body.payments
      fakeid = res.body.payments[0].id
      module.exports.getPaymentById fakeid, token, printResults
      console.log " "
      
    fakepayment = 
      intent: "sale"
      payer:
        payment_method: "credit_card"
        funding_instruments: [credit_card:
          number: "4417119669820331"
          type: "visa"
          expire_month: 11
          expire_year: 2018
          cvv2: 874
          first_name: "Joe"
          last_name: "Shopper"
          billing_address:
            line1: "52 N Main ST"
            city: "Johnstown"
            country_code: "US"
            postal_code: "43210"
            state: "OH"
        ]
      transactions: [
        amount:
          total: "7.47"
          currency: "USD"
          details:
            subtotal: "7.41"
            tax: "0.03"
            shipping: "0.03"
        description: "This is the FAKE transaction description."
      ]

    fakepayer =
      { payer_id : "7E7MGXCWTTKK2" }
      
    module.exports.createPayment fakepayment, token, (err,res) ->
      console.log "CREATE PAYMENT result : " , res.body
      console.log " "
      console.log "EXPECT ERROR: on static test data with message STATE INVALID"
      module.exports.executePayment res.body.id, fakepayer, token 
      console.log " "
    module.exports.getApprovedPayments token, (err,res) ->
      console.log res.body.payments[0]
      # module.exports.executePayment res.body.payments[0].id, fakepayer, token


module.exports.test()

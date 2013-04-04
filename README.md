# payjaq
======

## Node Examples for the Paypal REST API with jquery AJAX


### Featuring node jquery for the ajax.
See https://developer.paypal.com/webapps/developer/docs/api

## Install:
- Run the nodejs.org installer
- mkdir a project folder and cd there
- copy these files and package.json there
- `npm install jquery`
- `npm install coffee-script` if you want to use it

## Run:

`node payjaq_test.js` or `coffee payjaq_test.coffee`

Compile to javascript: `coffee -c payjaq_test.coffee`


## Notes: 
- The tests that try to execute a payment fail with PAYMENT_STATE_INVALID:
  running against static PayPal test objects has limitations.
- To be create live test objects, get a dev client id and secret from PayPal.
- Note the payment approval step must have been taken by the user for
  completePayment to succeed.
- Don't forget to redirect to approval_url listed in response links if using
  the paypal payment method.
- Since this is an example, uses a single-arg callback.
- Otherwise, it may be a callback per result state, using a common err handler.


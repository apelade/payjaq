###
# payjaq
======

## Node Examples for the _PayPal_ REST API with jquery AJAX

### Featuring [node jquery](https://github.com/coolaj86/node-jquery)
- For Windows, at least Win7-64, it has dependencies that require installing Visual Studio and updating your 2010 C++ redistributables. Maybe 20 minutes, 500 MB. Sooo, if you are on Windows, and want a quicker demo, or you like TJ Holowaychuk's libs, look at this clone using SuperAgent: __[payper](https://github.com/apelade/payper)__.

### See the [PayPal API](https://developer.paypal.com/webapps/developer/docs/api)


## Install:
- Run the [nodejs.org](http://nodejs.org) installer.
- Save and extract the [zip file](https://github.com/apelade/payjaq/archive/master.zip) and open a terminal there.
- `npm install jquery`
- `npm install -g coffee-script` if desired?
- Now if you are on Windows, and it doesn't run right away, follow [TooTallNate's instructions](https://github.com/TooTallNate/node-gyp).


## Run:

`node payjaq_test.js` or `coffee payjaq_test.coffee`

`coffee -cb payjaq_test.coffee` compiles to javascript


## Notes:
- To create live test objects, get a dev client id and secret from PayPal.
- Immutable PayPal-hosted objects may have outages, like on 4/4/2013 2:15 PM Pacific, or go away. The error is:
  -  Err posting creds
  -  get_cred complete status: error
- The tests that try to execute a payment fail CORRECTLY with PAYMENT_STATE_INVALID running static PayPal test objects.
- Note the payment approval step must have been taken by the user for
  completePayment to succeed.
- Don't forget to redirect to approval_url listed in response links if using
  the paypal payment method.  See a [simple example.](https://github.com/apelade/sto/blob/master/route/index.coffee)
- Since this is an example, it uses a single-arg callback.
- Otherwise, it may be a callback per result state, using a common err handler.

### License:
MIT 


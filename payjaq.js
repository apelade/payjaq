// Generated by CoffeeScript 1.6.2
/*
Node Examples for the Paypal REST API with jquery AJAX
See https://github.com/apelade/payjaq/README.md for details
*/


(function() {
  var $, PAYMENT, ajaxGet, ajaxPost, printResults;

  printResults = function(res) {
    if (res != null) {
      return console.log(res);
    }
  };

  PAYMENT = 'https://api.sandbox.paypal.com/v1/payments/payment/';

  $ = require('jquery');

  ajaxPost = function(path, data, token, callback) {
    var setHeaders;

    setHeaders = function(xhr) {
      xhr.setRequestHeader('Content-Type', 'application/json');
      return xhr.setRequestHeader('Authorization', 'Bearer ' + token);
    };
    return $.ajax({
      type: "POST",
      url: PAYMENT + path,
      data: data,
      dataType: 'json',
      beforeSend: setHeaders
    }).success(function(res) {
      return callback(res);
    }).error(function(err) {
      console.log("ERROR on POST: data: ", data);
      return console.log("ERROR on POST: ", err);
    }).complete(function(xhr, status) {
      return console.log("post complete", status);
    });
  };

  ajaxGet = function(extra_path, token, callback) {
    var setHeaders;

    setHeaders = function(xhr) {
      xhr.setRequestHeader('Accept', 'application/json');
      return xhr.setRequestHeader('Authorization', 'Bearer ' + token);
    };
    return $.ajax({
      type: "GET",
      url: PAYMENT + extra_path,
      beforeSend: setHeaders
    }).success(function(res) {
      return callback(res);
    }).error(function(err) {
      return console.log("Error for ", extra_path);
    }).complete(function(xhr, status) {
      return console.log("get complete", status);
    });
  };

  module.exports.getToken = function(user, pass, callback) {
    var setCredHeaders;

    $.ajax({
      type: "POST",
      url: "https://api.sandbox.paypal.com/v1/oauth2/token",
      username: user,
      password: pass,
      data: {
        grant_type: 'client_credentials'
      },
      dataType: 'json',
      beforeSend: setCredHeaders
    }).success(function(res) {
      console.log("creds == Profit!");
      return callback(res);
    }).error(function(err) {
      return console.log("Err posting creds");
    }).complete(function(xhr, status) {
      return console.log("get_cred complete status: " + status);
    });
    return setCredHeaders = function(xhr) {
      xhr.setRequestHeader('Accept', 'application/json');
      return xhr.setRequestHeader('Accept-Language', 'en_US');
    };
  };

  module.exports.getAllPayments = function(token, callback) {
    if (callback == null) {
      callback = printResults;
    }
    return ajaxGet("", token, callback);
  };

  module.exports.getApprovedPayments = function(token, callback) {
    if (callback == null) {
      callback = printResults;
    }
    return ajaxGet('?state=approved', token, callback);
  };

  module.exports.getPaymentsPaged = function(token, callback) {
    if (callback == null) {
      callback = printResults;
    }
    return ajaxGet('?count=10', token, callback);
  };

  module.exports.getPaymentById = function(id, token, callback) {
    if (callback == null) {
      callback = printResults;
    }
    return ajaxGet(id, token, callback);
  };

  module.exports.createPayment = function(payment, token, callback) {
    if (callback == null) {
      callback = printResults;
    }
    return ajaxPost("", JSON.stringify(payment), token, callback);
  };

  module.exports.executePayment = function(idstr, payer, token, callback) {
    if (callback == null) {
      callback = printResults;
    }
    return ajaxPost("" + idstr + '/execute/', JSON.stringify(payer), token, callback);
  };

}).call(this);
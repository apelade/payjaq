###
  Node Examples for the Paypal REST API with jquery AJAX
  See https://github.com/apelade/payjaq/README.md for details
###

$ = require 'jquery'

printResults = (res) ->
  console.log res if res?

PAYMENT = 'https://api.sandbox.paypal.com/v1/payments/payment/'

###
  Three wrapper functions for each main ajax type we need.
  In this way setHeaders has token set for ajax beforeSend.
###

ajaxPost = (path, data, token, callback) ->

  setHeaders = (xhr) ->
    xhr.setRequestHeader('Content-Type', 'application/json')
    xhr.setRequestHeader('Authorization', 'Bearer ' + token)

  $.ajax(
    type: "POST"
    url : PAYMENT + path 
    data: data
    dataType: 'json'
    beforeSend: setHeaders
  )
  .success (res) ->
    callback res
  .error (err) ->
    console.log "ERROR on POST: data: ", data
    return console.log "ERROR on POST: ", err
  .complete (xhr, status) ->
    return console.log "post complete", status
    
ajaxGet = (extra_path, token, callback) ->
  
  setHeaders = (xhr) ->
    xhr.setRequestHeader('Accept', 'application/json')
    xhr.setRequestHeader('Authorization', 'Bearer ' + token)
    
  $.ajax(
    type: "GET"
    url: PAYMENT + extra_path
    beforeSend: setHeaders
  )
  .success (res) ->
    callback res
  .error (err) ->
    return console.log "Error for ", extra_path
  .complete (xhr, status) ->
    return console.log "get complete", status

###
  These functions could be called from Express server route files.
  Params userand pass are paypal sandbox credentials.
  Get your own for interaction with live paypal objects.
###  
    
module.exports.getToken = (user, pass, callback) ->

  $.ajax(
    type: "POST"
    url : "https://api.sandbox.paypal.com/v1/oauth2/token"
    username: user
    password: pass
    data: { grant_type : 'client_credentials' }
    dataType: 'json'
    beforeSend: setCredHeaders
  )
  .success (res) ->
    console.log "creds success"
    callback res
  .error (err) ->
    return console.log "Err posting creds"
  .complete (xhr, status) ->
    return console.log "get_cred complete status: " +status
    
  setCredHeaders = (xhr) ->
    xhr.setRequestHeader('Accept', 'application/json')
    xhr.setRequestHeader('Accept-Language', 'en_US')
    

module.exports.getAllPayments = ( token, callback = printResults) ->
  ajaxGet('', token, callback)

  
module.exports.getApprovedPayments = ( token, callback = printResults ) ->
  ajaxGet('?state=approved', token, callback)

  
module.exports.getPaymentsPaged = ( token, callback = printResults ) ->
  ajaxGet('?count=10', token, callback)


module.exports.getPaymentById = ( id, token, callback = printResults ) ->
  ajaxGet(id, token, callback)
 
 
module.exports.createPayment = ( payment, token, callback = printResults ) ->
  ajaxPost('', JSON.stringify(payment), token, callback)


module.exports.executePayment = ( id, payer, token, callback = printResults ) ->
  ajaxPost( id + '/execute/', JSON.stringify(payer), token, callback)


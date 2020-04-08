ruleset TwilioKeys {
  meta {
    shares __testing
    
     keys twilio_keys {
       "sid" : "SID",
       "token" : "TOKEN"
    }
    
  provide keys twilio_keys to TwilioModule
  }
}

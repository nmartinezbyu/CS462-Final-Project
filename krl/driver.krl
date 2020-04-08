ruleset driver {
  meta {
    shares __testing
  }
  global {
    __testing = { "queries":
      [ { "name": "__testing" }
      //, { "name": "entry", "args": [ "key" ] }
      ] , "events":
      [ //{ "domain": "d1", "type": "t1" }
      //, { "domain": "d2", "type": "t2", "attrs": [ "a1", "a2" ] }
      ]
    }
  }
  
  rule rumor {
    select when gossip rumor
    always {
      raise driver event "bid_available" attributes event:attrs
    }
  }
  
  rule new_message {
    select when flower new_order
    always {
      raise driver event "bid_available" attributes event:attrs
    }
  }
  
  rule bid_available {
    select when driver bid_available
    
    pre {
      distance = random:integer(200).klog("DISTANCE")
      orderId = event:attr("order"){"id"}.klog("ID")
      driver_eci = meta:eci.klog("DRIVER ECI")
      shop_eci = event:attr("order").get(["store", "eci"]).klog("SHOP ECI")
    }
    event:send({ "eci": shop_eci, "eid": "new_order",
          "domain": "pttm", "type": "incoming_bid",
          "attrs": { "distance": distance, "orderId": orderId, "driverECI": driver_eci } })
  }
}

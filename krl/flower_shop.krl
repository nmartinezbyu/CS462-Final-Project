ruleset flower_shop {
  meta {
    shares __testing, getProfile, selectBid
    use module io.picolabs.subscription alias sub
  }
  
  global {
    __testing = { "queries":
      [ { "name": "__testing" }
      , { "name": "getProfile" }
      , { "name": "selectBid", "args": ["id"] }
      ] , "events":
      [ { "domain": "pttm", "type": "update_profile", "attrs": [ "name", "lat", "lon" ] }
      , { "domain": "pttm", "type": "create_order", "attrs": [ "customer" ] }
      ]
    }
    getProfile = function() {
      {
        "name": ent:name.defaultsTo("Shop"),
        "lat": ent:lat.defaultsTo(0),
        "lon": ent:lon.defaultsTo(0)
      }
    }
    
    selectBid = function(id) {
      ent:bids{id}.sort(function(a, b) {
        a{"distance"} < b{"distance"}  => -1 | a{"distance"} == b{"distance"} =>  0 | 1
      }).head(){"eci"}
    }
  }
  
  rule update_profile {
    select when pttm update_profile
    
    pre {
      name = event:attr("name")
      lat = event:attr("lat")
      lon = event:attr("lon")
    }
    
    always {
      ent:name := name.defaultsTo(ent:name)
      ent:lat := lat.defaultsTo(ent:lat)
      ent:lon := lon.defaultsTo(ent:lon)
    }
  }
  
  rule create_order {
    select when pttm create_order
    
    pre {
      id = random:uuid()
      customer = event:attr("customer")
      order = {
        "id": id,
        "store": {
          "eci": meta:eci,
          "name": ent:name,
          "location": {
            "latitude": ent:lat,
            "longitude": ent:lon
          }
        },
        "customer": customer,
        "status": "pending",
        "date": time:now()
      }
    }
    
    fired {
      ent:orders := ent:orders.defaultsTo({}).put(id, order)
      raise pttm event "inform_drivers" attributes {
        "order": order
      }
    }
  }
  
  rule inform_drivers {
    select when pttm inform_drivers
    
    foreach sub:established("Tx_role", "driver") setting (x)
      pre {
        order = event:attr("order")
      }
      event:send({ "eci": x{"Tx"}, "eid": "new_order",
          "domain": "flower", "type": "new_order",
          "attrs": { "order": order } })
      fired {
        // todo: add scheduled event that selects a bid from what have been received in 15 seconds // on final
      }
  }
  
  rule incoming_bid {
    select when pttm incoming_bid
    
    pre {
      distance = event:attr("distance")
      orderId = event:attr("orderId")
      driverECI = event:attr("driverECI")
      object = {
        "distance": distance,
        "orderId": orderId,
        "eci": driverECI
      }
    }
    
    if distance && orderId && driverECI then noop();
    
    fired {
      ent:bids{orderId} := ent:bids{orderId}.defaultsTo([]).append(object)
    }
  }
  
  rule select_bid {
    select when pttm select_bid
    pre {
      id = event:attr("id")
      eci = selectBid(id)
    }
  }
}

/*
  
{
  "id": "ord_123456789",
  "store": {
    "eci": "cjV800s3Slke3JFl3",
    "name": "Petalz 4 Dayz",
    "location": {
      "latitude": -111.450948,
      "longitude": 69.69
    },
  },
  "customer": {
    "location": {
      "latitude": -111.1,
      "longitude": 69.96
    }
  },
  "status": "pending" | "accepted" | "fulfilled",
  "date": 46654346754,
  "driver": "dri_123456789",
}
*/
